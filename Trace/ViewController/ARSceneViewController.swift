//
//  ViewController.swift
//  Trace
//
//  Created by Minki on 2017. 10. 16..
//  Copyright © 2017년 Shifter. All rights reserved.
//

import UIKit
import ARKit
class ARSceneViewController: UIViewController, UITextFieldDelegate, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    var naviColor: UIColor?
    @IBOutlet weak var myPageBarButton: UIBarButtonItem!
    
    @IBOutlet weak var leftButton: ARBlueBottomButton!
    @IBOutlet weak var rightButton: ARBlueBottomButton!
    @IBOutlet weak var depthSlider: UISlider!
    @IBOutlet weak var objTextField: UITextField!
    
    var textContentsList = [TextVO]()
    var currentScreenState = Mode.Display
    let initScale = SCNVector3(0.005, 0.005, 0.005)
    let defaultPosition = SCNVector3(-0.14, -0.08, -0.6)
    var isReadyToHangTheObject = false
    
    enum Mode {
        case Text
        case Image
        case Display
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// AR View 디버그 옵션. ARSCNDebugOptions.showFeaturePoints - featurepoints 표시, ARSCNDebugOptions.showWorldOrigin - 월드 좌표 원점 표시
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        /// myPage로 이동하기
        myPageBarButton.target = self
        myPageBarButton.action = #selector(movePage(_:))
        
        /// navigationbar 투명하게 만들기 (2줄)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        /// 슬라이더바 세로로 세우기
        self.depthSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        
        /// TextField Delegate 설정
        self.objTextField.delegate = self
        
        self.sceneView.session.run(AppDelegate.configuration)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        /// navigationbar 투명하게 만들기 (1줄)
        self.navigationController?.navigationBar.isTranslucent = true
        
        /// 추가된 텍스트 컨텐츠들 걸어 놓기.
        for obj in textContentsList {
            self.sceneView.scene.rootNode.addChildNode(createNode(nodeOption: obj))
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        switch currentScreenState {
        case .Display:
            print("Display")
        case .Text:
            print("Text")
        case .Image:
            print("Image")
        }
        
        return true
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
    
    @IBAction func onLeftButtonClicked(_ sender: ARBlueBottomButton) {
        switch currentScreenState {
        case .Display:
            self.currentScreenState = .Text
            self.leftButton.setTitle("CANCEL", for: .normal)
            self.rightButton.setTitle("POST", for: .normal)
            self.depthSlider.isHidden = false   // 보이게
            self.depthSlider.value = 0.0
            self.objTextField.becomeFirstResponder()
            self.isReadyToHangTheObject = false
            
        case .Text: //
            print("TEXT")
        case .Image:
            print("Image")
        }
    }
    
    @IBAction func onRightButtonClicked(_ sender: ARBlueBottomButton) {
        switch currentScreenState {
        case .Display:
            self.currentScreenState = .Image
        case .Text:
            print("Text")
        case .Image:
            print("Image")
        }
    }
    
}

