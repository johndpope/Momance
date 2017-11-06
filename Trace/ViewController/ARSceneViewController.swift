//
//  ARSceneViewController.swift
//  Trace
//
//  Created by Minki on 2017. 10. 16..
//  Copyright © 2017년 Shifter. All rights reserved.
//

import UIKit
import ARKit
//
class ARSceneViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var myPageBarButton: UIBarButtonItem!
    @IBOutlet weak var mainNavigationBar: UINavigationItem!
    
    var naviColor: UIColor? // 타이틀 컬러는 AR화면일 때, 투명으로 해주기 위한 변수
    var currentScreenState = Mode.Display
    let defaultTextScale = SCNVector3(0.005, 0.005, 0.005)
    let defaultTextPosition = SCNVector3(-0.14, -0.08, -0.6)
    let defaultImageScale = SCNVector3(3.0, 3.0, 3.0)
    let defaultImagePosition = SCNVector3(0.0, 0.0, -0.6)
    
    var isReadyToHangTheObject = false      // 지금 걸고 있는 화면인지 아닌지
    var isGalleryOn = false                 // 갤러리 때문에 ARSCNView가 viewWillAppear에서 두번 가동되는 일이 없도록 하는 flag
    
    var textContentsList = [TextVO]()       // 화면에 보일 모든 텍스트 리스트에 대한 속성 값들
    var textNodeObject: SCNText?            // 가장 최근에 걸어 놓은 텍스트 오브젝트 내용물
    var textContent: String?                // 오브젝트의 String 값
    
    var imageContentsList = [ImageVO]()     // 화면에 보일 모든 이미지 리스트에 대한 속성 값들
    var imageNodeObject: SCNPlane?          // 가장 최근에 걸어 놓은 이미지 오브젝트 내용물
    var imageContent: UIImage?              // 오브젝트의 실제 UIImage 값
    
    // xib로 구성된 화면 껍질들
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
        
        // AR View 디버그 옵션. ARSCNDebugOptions.showFeaturePoints - featurepoints 표시, ARSCNDebugOptions.showWorldOrigin - 월드 좌표 원점 표시
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // myPage로 이동하기
        myPageBarButton.target = self
        myPageBarButton.action = #selector(movePage(_:))
        
        // navigationbar 투명하게 만들기 (2줄)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // UIMainSCNView.xib파일 불러오기
        createMainSceneObjects()
    }
    
    /// MainScene에서 Text버튼 눌렀을 때
    @objc func onTextButtonClicked(_ sender: UIButton) {    // 완료.
        createTextSceneObjects()
    }
    /// MainScene에서 Camera버튼 눌렀을 때
    @objc func onImageButtonClicked(_ sender: UIButton) {   // 완료.
        createImageSceneObjects()
    }
    
    /// TextScene에서 Cancel버튼 눌렀을 때
    @objc func onCancelButtonClickedInTextScene(_ sender: UIButton) {
        // TODO: textField, slider 초기화 - textFieldShouldReturn에서 해준거 반대로
        recreateTextScene()
        // TOKNOW: textScnView를 deallocate 해줘야 메모리에서 해제될까??
    }
    /// TextScene에서 Post버튼 눌렀을 때
    @objc func onPostButtonClickedInTextScene(_ sender: UIButton) {
        
        hangTheText()               // 텍스트 걸고
        removeTextSceneObjects()    // 텍스트 Scene 지우고
        createMainSceneObjects()    // 메인 Scene 생성
    }
    
    /// ImageScene에서 gallery버튼 눌렀을 때
    @objc func onGalleryButtonClickedInImageScene(_ sender: UIButton) {
        // Photo Gallery 띄우기
        showGallery()
        
    }
    /// ImageScene에서 capture버튼 눌렀을 때
    @objc func onCaptureButtonClickedInImageScene(_ sender: UIButton) {
        // 사진찍고 Post화면 띄우기
        underImageCapturing(uiImage: sceneView.snapshot())
    }
    
    /// ImageScene에서 turnCamera버튼 눌렀을 때
    @objc func onTurnCameraButtonClickedInImageScene(_ sender: UIButton) {
        // 카메라 반전
        print("onTurnCameraButtonClickedInImageScene")
    }
    
    /// ImageScene에서 Cancel버튼 눌렀을 때
    @objc func onCancelButtonClickedInImageScene(_ sender: UIButton) {
        recreateImageScene()        // 이미지 뷰 재생성
        self.isReadyToHangTheObject = false
    }
    
    /// ImageScene에서 Post버튼 눌렀을 때
    @objc func onPostButtonClickedInImageScene(_ sender: UIButton) {
        
        self.imageScnView?.selectOptionView.isHidden = false
        self.imageScnView?.cancelButton.isHidden = true
        self.imageScnView?.postButton.isHidden = true
        self.imageScnView?.depthSlider.isHidden = true
        
        hangTheImage()               // 이미지 걸고
        removeImageSceneObjects()    // 이미지 Scene 지우고
        createMainSceneObjects()    // 메인 Scene 생성
    }
    
    /// 깊이 조절 slider bar event handler
    @objc func onDepthSliderValueChanged(_ sender: UISlider) {
        
//        self.textScnView?.onDepthValueChanged(sender)
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
       
//        if !isGalleryOn {
            self.sceneView.session.run(AppDelegate.configuration)
//        } else {    // 갤러리 땜에 다시 켜진거면 이쪽으로.
//            self.isGalleryOn = false
//        }
        if isGalleryOn {
            underImageCapturing(uiImage: imageContent!)
            isGalleryOn = false
        }
        
        /// navigationbar 투명하게 만들기 (1줄)
        self.navigationController?.navigationBar.isTranslucent = true
        
        /// 추가된 텍스트 컨텐츠들 걸어 놓기.
        for obj in textContentsList {
            self.sceneView.scene.rootNode.addChildNode(createNode(textNodeOption: obj))
        }
        
        /// 추가된 이미지 컨텐츠들 걸어 놓기.
        for obj in imageContentsList {
            self.sceneView.scene.rootNode.addChildNode(createNode(imageNodeOption: obj))
        }
        print("viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 화면 사라지면 세션 멈추기.
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }

    /// myPage로 이동하는 세그웨이 구현 메소드
    @objc func movePage(_ sender: Any) {
        
        if sender is UIBarButtonItem {
            let segueName = "segueMyPage"
            self.performSegue(withIdentifier: segueName, sender: self)
        }
    }
    
    /// deprecated
    @IBAction func unwindToMainVC(segue: UIStoryboardSegue) {
        
        // ARTextViewController에서 생성된 컨텐츠를 추가하는 부분.
        let vc = segue.source as! ARTextViewController
        if let textNode = vc.realTextNode, let textContent = vc.textContent {
            textContentsList.append(
                TextVO(x: textNode.worldPosition.x, y: textNode.worldPosition.y, z: textNode.worldPosition.z,
                       orientationX: textNode.worldOrientation.x, orientationY: textNode.worldOrientation.y, orientationZ: textNode.worldOrientation.z,
                       textContent: textContent))
        }
    }
}

/// Delegate 메소드 구현
extension ARSceneViewController: UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// textField에 텍스트를 입력 중인 상태에서 키보드 Done키를 눌렀을 때 수행하는 메소드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {  // 완료.
        if textField.text == "" {
            // TODO: 입력하라고 힌트 주기
            return false
        }
        
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
        scnNode.scale = self.defaultTextScale
        scnNode.position = self.defaultTextPosition
        self.sceneView.pointOfView?.addChildNode(scnNode)
        
        return true
    }
    
    /// 포토 갤러리 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let uiImage = info[UIImagePickerControllerEditedImage] as? UIImage { // 이미지를 제대로 받아왔으면
            
//            self.sceneView.session.run(AppDelegate.configuration)   // 이 메소드가 viewWillAppear보다 먼저 실행되서 여기서는 먼저 ARSCNView를 실행해야함
//            underImageCapturing(uiImage: uiImage)
            imageContent = uiImage
            isGalleryOn = true
        }
        // picker 화면 없애고
        picker.dismiss(animated: true)
        
        // TODO: 이미지 제대로 안왔다고 힌트 주기
    }
}

/// Handler안에서의 로직 구현코드가 들어있음 - 위에는 주로 Handler메소드 구현
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
        
        self.imageScnView?.galleryButton.addTarget(self, action: #selector(onGalleryButtonClickedInImageScene(_:)), for: .touchUpInside)
        self.imageScnView?.captureButton.addTarget(self, action: #selector(onCaptureButtonClickedInImageScene(_:)), for: .touchUpInside)
        self.imageScnView?.turnCameraButton.addTarget(self, action: #selector(onTurnCameraButtonClickedInImageScene(_:)), for: .touchUpInside)
        self.imageScnView?.cancelButton.addTarget(self, action: #selector(onCancelButtonClickedInImageScene(_:)), for: .touchUpInside)
        self.imageScnView?.postButton.addTarget(self, action: #selector(onPostButtonClickedInImageScene(_:)), for: .touchUpInside)
        self.imageScnView?.depthSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        
        /// 슬라이더바 초기화
        self.imageScnView?.isHidden = true
        self.imageScnView?.depthSlider.value = 0.0
        
        /// 슬라이더바 value change 관련 이벤트 핸들러 추가
        self.imageScnView?.depthSlider.addTarget(self, action: #selector(onDepthSliderValueChanged(_:)), for: .touchUpInside)
        
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
    
    func recreateImageScene() {
        self.isReadyToHangTheObject = false
        self.imageScnView?.depthSlider.value = 0.0
        self.sceneView.pointOfView?.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
    
    /// 대기중인 텍스트를 걸어놓는 메소드
    func hangTheText() {
        if self.isReadyToHangTheObject {     // 걸어 놓을 준비가 되었다면 탭 제스처를 인식
            
            self.isReadyToHangTheObject = false
            
            let textNode = SCNNode(geometry: textNodeObject)
            guard let worldPosition = (self.sceneView.pointOfView?.childNodes[0].worldPosition) else {
                print("pointOfView의 childNodes가 없습니다.")
                return
            }
            guard let cameraOrientation = (self.sceneView.pointOfView?.orientation) else {
                print("pointOfView의 childNodes가 없습니다.")
                return
            }
            
            textNode.scale = defaultTextScale
            textNode.position = worldPosition
            textNode.orientation = cameraOrientation
            if let content = textContent {
                textContentsList.append(TextVO(x: textNode.worldPosition.x, y: textNode.worldPosition.y, z: textNode.worldPosition.z, orientationX: textNode.orientation.x, orientationY: textNode.orientation.y, orientationZ: textNode.orientation.z, textContent: content))
            }
            
            /// 추가된 컨텐츠들 걸어놓기
            self.sceneView.scene.rootNode.addChildNode(textNode)
            self.sceneView.pointOfView?.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }
            
            
        }
    }
    
    /// 대기중인 이미지를 걸어놓는 메소드
    func hangTheImage() {
        if self.isReadyToHangTheObject {
            self.isReadyToHangTheObject = false
            
            let imageNode = SCNNode(geometry: imageNodeObject)
            guard let worldPosition = (self.sceneView.pointOfView?.childNodes[0].worldPosition) else {
                print("pointOfView의 childNodes가 없습니다.")
                return
            }
            guard let cameraOrientation = (self.sceneView.pointOfView?.orientation) else {
                print("pointOfView의 childNodes가 없습니다.")
                return
            }
            
            imageNode.scale = self.defaultImageScale
            imageNode.position = worldPosition
            imageNode.orientation = cameraOrientation
            
            if let content = imageContent {
                imageContentsList.append(ImageVO(x: imageNode.worldPosition.x, y: imageNode.worldPosition.y, z: imageNode.worldPosition.z, orientationX: imageNode.orientation.x, orientationY: imageNode.worldPosition.y ,orientationZ: imageNode.worldPosition.z, imageContent: content))
            }
            
            /// 추가된 컨텐츠 걸어놓기
            self.sceneView.scene.rootNode.addChildNode(imageNode)
            self.sceneView.pointOfView?.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }
        }
    }
    
    /// x, y, z, 텍스트 값을 가지고 있는 TextVO의 객체를 넣어주면 node를 반환한다.
    func createNode(textNodeOption option: TextVO!) -> SCNNode{         // optional unwrapping 주의 함수.
        
        let tNode = SCNText(string: option.textContent, extrusionDepth: 1)
        tNode.flatness = 0
        let textNode = SCNNode(geometry: tNode)
        textNode.name = "textNode"
        textNode.scale = self.defaultTextScale
        textNode.position = SCNVector3(option.x!, option.y!, option.z!)
        
        return textNode
    }
    
    /// x, y, z, UIImage 값을 가지고 있는 ImageVO의 객체를 넣어주면 node를 반환한다.
    func createNode(imageNodeOption option: ImageVO!) -> SCNNode{         // optional unwrapping 주의 함수.
        
        let iNode = SCNPlane(width: 1, height: 1)
        iNode.firstMaterial?.diffuse.contents = imageContent
        let imageNode = SCNNode(geometry: iNode)
        imageNode.name = "imageNode"
        imageNode.position = SCNVector3(option.x!, option.y!, option.z!)
        
        return imageNode
    }
    
    /// Photo Gallery 실행하는 메소드
    func showGallery() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    func underImageCapturing(uiImage: UIImage) {
        
        // button 셋팅
        self.imageScnView?.selectOptionView.isHidden = true
        self.imageScnView?.cancelButton.isHidden = false
        self.imageScnView?.postButton.isHidden = false
        self.imageScnView?.depthSlider.isHidden = false
        
        // 걸어놓을 준비가 되었다는 것을 알림
        self.isReadyToHangTheObject = true
        
        // image를 평면에 셋팅
        let imagePlane = SCNPlane(width: self.sceneView.bounds.width/6000, height: sceneView.bounds.height/6000)
        imagePlane.firstMaterial?.diffuse.contents = uiImage
        imagePlane.firstMaterial?.lightingModel = .constant
        
        self.imageNodeObject = imagePlane   // 지금 등록한 오브젝트가 뭔지 잠시 저장
        
        let scnNode = SCNNode(geometry: imagePlane)
        scnNode.name = "imageNode"
        scnNode.scale = self.defaultImageScale
        scnNode.position = self.defaultImagePosition
        self.sceneView.pointOfView?.addChildNode(scnNode)
        
        // depthSlider가 작동하도록.
//        self.imageScnView?.depthSlider.addTarget(self, action: #selector(onDepthSliderValueChanged(_:)), for: .touchUpInside)
    }
}

/**
 xib 관련 개념 링크 - http://suho.berlin/engineering/ios/ios-storyboard-nibxib-code/
 
 */

