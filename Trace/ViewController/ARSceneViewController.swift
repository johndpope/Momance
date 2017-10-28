//
//  ARSceneViewController.swift
//  Trace
//
//  Created by Minki on 2017. 10. 16..
//  Copyright © 2017년 Shifter. All rights reserved.
//

import UIKit
import ARKit
class ARSceneViewController: UIViewController, ARSCNViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var myPageBarButton: UIBarButtonItem!
    
    var naviColor: UIColor?
    var textContentsList = [TextVO]()
    var currentScreenState = Mode.Display
    let initScale = SCNVector3(0.005, 0.005, 0.005)
    let defaultPosition = SCNVector3(-0.14, -0.08, -0.6)
    var isReadyToHangTheObject = false
    var textNodeObject: SCNText?
    var textContent: String?
    
    var mainScnView: UIMainSCNView?
    var textScnView: UITextSCNView?
    var imageScnView: UIImageSCNView?
    
    enum Mode {
        case Text
        case Image
        case Display
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// AR View 디버그 옵션. ARSCNDebugOptions.showFeaturePoints - featurepoints 표시, ARSCNDebugOptions.showWorldOrigin - 월드 좌표 원점 표시
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        /// myPage로 이동하기
        myPageBarButton.target = self
        myPageBarButton.action = #selector(movePage(_:))
        
        /// navigationbar 투명하게 만들기 (2줄)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        /// UIMainSCNView.xib파일 불러오기
        createMainSceneObjects()
        
    }
    
    @objc func onTextButtonClicked(_ sender: UIButton) {    // 완료.
        createTextSceneObjects()
    }
    @objc func onImageButtonClicked(_ sender: UIButton) {   // 완료.
        createImageSceneObjects()
    }
    
    @objc func onCancelButtonClickedInTextScene(_ sender: UIButton) {
//        removeTextSceneObjects()    // ImageSCN 지우고
        // TODO: textField, slider 초기화 - textFieldShouldReturn에서 해준거 반대로
        
        createMainSceneObjects()    // MainSCN 재생성
        // TOKNOW: textScnView를 deallocate 해줘야 메모리에서 해제될까??
    }
    @objc func onPostButtonClickedInTextScene(_ sender: UIButton) {
        
        hangTheText()               // 텍스트 걸고
        removeTextSceneObjects()    // 텍스트 Scene 지우고
        createMainSceneObjects()    // 메인 Scene 생성
    }

    @objc func onCancelButtonClickedInImageScene(_ sender: UIButton) {
//        removeImageSceneObjects()   // ImageSCN 지우고
        recreateTextScene()
        createMainSceneObjects()    // MainSCN 재생성
    }
    @objc func onPostButtonClickedInImageScene(_ sender: UIButton) {
        
    }
    
    /// 깊이 조절 slider bar event handler
    @objc func onDepthSliderValueChanged(_ sender: UISlider) {
        self.textScnView?.onDepthValueChanged(sender)
        if self.isReadyToHangTheObject {
            if sender.value >= 10.0 {
                sender.value = 10.0
            }
            guard let pointOfView = self.sceneView.pointOfView else {
                return
            }
            pointOfView.childNodes[0].position.z = -sender.value-0.6
        }
        print("value in mainscene:\(sender.value)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /// ARSCNView 구동하기
        self.sceneView.session.run(AppDelegate.configuration)
        
        /// navigationbar 투명하게 만들기 (1줄)
        self.navigationController?.navigationBar.isTranslucent = true
        
        /// 추가된 텍스트 컨텐츠들 걸어 놓기.
        for obj in textContentsList {
            self.sceneView.scene.rootNode.addChildNode(createNode(nodeOption: obj))
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 화면 사라지면 세션 멈추기.
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }

    // myPage로 이동하는 세그웨이 구현 메소드
    @objc func movePage(_ sender: Any) {
        
        if sender is UIBarButtonItem {
            let segueName = "segueMyPage"
            self.performSegue(withIdentifier: segueName, sender: self)
        }
    }
    
    @IBAction func unwindToMainVC(segue: UIStoryboardSegue) {
        
        // ARTextViewController에서 생성된 컨텐츠를 추가하는 부분.
        let vc = segue.source as! ARTextViewController
        if let textNode = vc.realTextNode, let textContent = vc.textContent {
            textContentsList.append(TextVO(x: textNode.worldPosition.x, y: textNode.worldPosition.y, z: textNode.worldPosition.z, textContent: textContent))
//            TextVO(x: <#T##Float?#>, y: <#T##Float?#>, z: <#T##Float?#>, textContent: <#T##String?#>, red: <#T##Float?#>, green: <#T##Float?#>, blue: <#T##Float?#>)
            
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {  // 완료.
        print("In ARSceneViewController")
        self.textContent = textField.text!
        self.textNodeObject = SCNText(string: self.textContent, extrusionDepth: 1)
        
        guard let textNodeInScnNode = textNodeObject else {     // TOKNOW: reference복사 되겠지?
            return false
        }
        textNodeInScnNode.flatness = 0
        
        self.isReadyToHangTheObject = true
        textField.isHidden = true
        textField.resignFirstResponder()
        textField.text = ""
        
        let scnNode = SCNNode(geometry: textNodeInScnNode)
        scnNode.name = "textNode"
        scnNode.scale = self.initScale
        scnNode.position = self.defaultPosition
        self.sceneView.pointOfView?.addChildNode(scnNode)
        
        return true
    }
    
}

// Handler안에서의 로직 구현코드가 들어있음 - 위에는 주로 Handler메소드 구현
extension ARSceneViewController {
    
    func createMainSceneObjects() {
        
        self.mainScnView = (Bundle.main.loadNibNamed("UIMainSCNView", owner: self, options: nil)?[0] as! UIMainSCNView) // 궁금.. -> 괄호치면 왜 warning이 없어질까?
        self.sceneView.addSubview(mainScnView!)    // 위에서 넣어줬으니 바로 언래핑해도됨.
        
        self.mainScnView?.textButton.addTarget(self, action: #selector(onTextButtonClicked(_:)), for: .touchUpInside)
        self.mainScnView?.imageButton.addTarget(self, action: #selector(onImageButtonClicked(_:)), for: .touchUpInside)
    }
    
    func createTextSceneObjects() {
        self.mainScnView?.removeFromSuperview()
        self.textScnView = (Bundle.main.loadNibNamed("UITextSCNView", owner: self, options: nil)?[0] as! UITextSCNView)
        self.sceneView.addSubview(self.textScnView!)
        
        self.textScnView?.objTextField.delegate = self
        self.textScnView?.cancelButton.addTarget(self, action: #selector(onCancelButtonClickedInTextScene(_:)), for: .touchUpInside)
        self.textScnView?.postButton.addTarget(self, action: #selector(onPostButtonClickedInTextScene(_:)), for: .touchUpInside)
        self.textScnView?.depthSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        
        /// 슬라이더바 초기화
        self.textScnView?.depthSlider.value = 0.0
    
        /// 슬라이더바 value change 관련 이벤트 핸들러 추가
        self.textScnView?.depthSlider.addTarget(self, action: #selector(onDepthSliderValueChanged(_:)), for: .touchUpInside)
        
        /// 들어오자마자 텍스트필드 포커스
        self.textScnView?.objTextField.becomeFirstResponder()
    }
    
    func createImageSceneObjects() {
        
        self.mainScnView?.removeFromSuperview()
        self.imageScnView = (Bundle.main.loadNibNamed("UIImageSCNView", owner: self, options: nil)?[0] as! UIImageSCNView)
        self.sceneView.addSubview(self.imageScnView!)
        
        //        self.imageScnView?.cancelButton.addTarget()
        //        self.imageScnView?.postButton.addTarget()
    }
    
    func removeTextSceneObjects() {
        self.textScnView?.removeFromSuperview()
    }
    func removeImageSceneObjects() {
        self.imageScnView?.removeFromSuperview()
    }
    
    func recreateTextScene() {
        self.isReadyToHangTheObject = false
        self.textScnView?.objTextField.isHidden = false
        self.textScnView?.objTextField.becomeFirstResponder()
        self.textScnView?.depthSlider.value = 0.0
        self.sceneView.pointOfView?.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
    
    func hangTheText() {
        if self.isReadyToHangTheObject {     // 걸어 놓을 준비가 되었다면 탭 제스처를 인식
            
            self.isReadyToHangTheObject = false
            
            let textNode = SCNNode(geometry: textNodeObject)
            guard let world = (self.sceneView.pointOfView?.childNodes[0].worldPosition) else {
                print("pointOfView의 childNodes가 없습니다.")
                return
            }
            
            textNode.scale = initScale
            textNode.position = world
            
            if let content = textContent {
                textContentsList.append(TextVO(x: textNode.worldPosition.x, y: textNode.worldPosition.y, z: textNode.worldPosition.z, textContent: content))
            }
            
            /// 추가된 컨텐츠들 걸어놓기
            self.sceneView.scene.rootNode.addChildNode(textNode)
            self.sceneView.pointOfView?.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }
            
            
        }
    }
    
    /// x, y, z, 텍스트 값을 가지고 있는 TextVO의 객체를 넣어주면 node를 반환한다.
    func createNode(nodeOption option: TextVO!) -> SCNNode{         // optional unwrapping 주의 함수.
        
        let tNode = SCNText(string: option.textContent, extrusionDepth: 1)
        tNode.flatness = 0
        let textNode = SCNNode(geometry: tNode)
        textNode.name = "textNode"
        textNode.scale = self.initScale
        textNode.position = SCNVector3(option.x!, option.y!, option.z!)
        
        return textNode
    }
}

