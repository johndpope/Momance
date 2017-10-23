//
//  ARTextViewController.swift
//  Trace
//
//  Created by Minki on 2017. 10. 16..
//  Copyright © 2017년 Shifter. All rights reserved.
//

import UIKit
import ARKit

class ARTextViewController: UIViewController, UITextFieldDelegate, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var depthSlider: UISlider!
    @IBOutlet weak var objTextField: UITextField!
    let configuration = ARWorldTrackingConfiguration()
    
    var uploadTextModel = UploadTextModel()
    
    // 텍스트 입력해서 걸어놓을 준비 중 일때 true
    var isReadyToHangTheObject = false
    var textContent: String?
    var textNodeObject: SCNText?
    let initScale = SCNVector3(0.005, 0.005, 0.005)
    let defaultPosition = SCNVector3(-0.14, -0.08, -0.6)
    var realTextNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.delegate = self
        self.sceneView.autoenablesDefaultLighting = true
        
        self.depthSlider.isEnabled = false  // 맨첨에 슬라이더 못만지게
        self.depthSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))    // slider바 세로로 세우기.
        self.objTextField.delegate = self
        self.objTextField.becomeFirstResponder()    // 초기 선택
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognize:)))
        self.sceneView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        self.sceneView.session.run(AppDelegate.configuration)
    }
    
    func restartSession() {
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    @IBAction func toggleARSwitch(_ sender: UISwitch) {
        if sender.isOn {
            
        } else {
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.textContent = textField.text!
        self.textNodeObject = SCNText(string: textContent, extrusionDepth: 1)
        
        guard let tNode = textNodeObject else{
            return false
        }
        
        self.depthSlider.isEnabled = true
        self.isReadyToHangTheObject = true
        textField.isHidden = true
        textField.resignFirstResponder()
        textField.text = ""
        
//        tNode.alignmentMode = kCAAlignmentCenter
//        tNode.font = UIFont(name: "Gulim", size: 10)
        tNode.flatness = 0
        let textNode = SCNNode(geometry: tNode)
        textNode.name = "textNode"
        textNode.scale = self.initScale
        textNode.position = self.defaultPosition
        self.sceneView.pointOfView?.addChildNode(textNode)
        return true
    }
    
    
    
    @IBAction func adjustDepth(_ sender: UISlider) {
        if isReadyToHangTheObject {
            if sender.value >= 10.0 {
                sender.value = 10.0
            }
            guard let pointOfView = self.sceneView.pointOfView else {
                return
            }
            pointOfView.childNodes[0].position.z = -sender.value-0.6
        }
    }
    
    @objc func handleTap(gestureRecognize: UITapGestureRecognizer) {
        
        self.sceneView.updateFocusIfNeeded()
    }
    
    @IBAction func onCancelClicked(_ sender: ARBlueBottomButton) {
        self.depthSlider.isEnabled = true
        self.depthSlider.isHidden = false
        self.depthSlider.value = 0.0
        self.objTextField.isHidden = false
        self.objTextField.becomeFirstResponder()
        self.isReadyToHangTheObject = false
        self.sceneView.pointOfView?.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
    
    @IBAction func onPostClicked(_ sender: ARBlueBottomButton) {
        if self.isReadyToHangTheObject {     // 걸어 놓을 준비가 되었다면 탭 제스처를 인식
            
            
            let textNode = SCNNode(geometry: textNodeObject)
            guard let world = (self.sceneView.pointOfView?.childNodes[0].worldPosition) else {
                print("pointOfView의 childNodes가 없습니다.")
                return
            }
            
            textNode.scale = initScale
            textNode.position = world
            
            realTextNode = textNode // SCNNode관련 전역 object 
            
            // 앞화면으로 넘어가는 거면 이거 필요없어짐. 그냥 textNode만 넘겨주면된다.
            self.sceneView.scene.rootNode.addChildNode(textNode)
            self.sceneView.pointOfView?.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }
            
            self.depthSlider.isHidden = true
            self.isReadyToHangTheObject = false
            
            /// TODO: 데이터 저장하는 메소드.
//            uploadTextModel.setUploadContents(x: world.x, y: world.y, z: world.z, text: textContent!, list: &ARSceneViewController.textContentsList) // 입력받은 텍스트와 좌표를 여기에 넣어줌.
            
            performSegue(withIdentifier: "unwindSegueToMainVC", sender: self)
        }
    }
    
}

//extension Int {
//    var degreesToRadian: Double { return Double(self) * .pi / 180 }
//}
//
//func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
//    return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
//}

