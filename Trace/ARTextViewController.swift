//
//  ARTextViewController.swift
//  Trace
//
//  Created by Minki on 2017. 10. 16..
//  Copyright © 2017년 Shifter. All rights reserved.
//

import UIKit
import ARKit

class ARTextViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var depthSlider: UISlider!
    @IBOutlet weak var objTextField: UITextField!
    //    @IBOutlet var realTextField: UITextField!
//
//    let customTextField = UITextField()
    let configuration = ARWorldTrackingConfiguration()
    
//    var screenMode = TextScreenMode.inputMode
    
    var uploadTextModel = UploadTextModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.realTextField.delegate = self
//        self.realTextField.becomeFirstResponder()
//        self.customTextField.inputAccessoryView = realTextField
//        self.customTextField.returnKeyType = .next
//        screenMode = .inputMode
//        toggleScreenComponents()
//        print("viewdidload")
        self.sceneView.autoenablesDefaultLighting = true
        
        self.depthSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        self.objTextField.delegate = self
        self.objTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        self.sceneView.session.run(AppDelegate.configuration)
        print("viewWillAppear")
    }
    
    func restartSession() {
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        // 실제 입력하는 것은 realTextField이다.
//        print("\(textField.text!)")
//        // 처리
//        screenMode = .displayMode
//        toggleScreenComponents()
//
//        textField.text = ""
//        return true
//    }
//    
//    func toggleScreenComponents() {
//        switch screenMode {
//        case .inputMode:    // 텍스트 입력 모드
//            print("inputMode")
//            self.customTextField.becomeFirstResponder()
//            self.sceneView.addSubview(customTextField)
//
//        case .displayMode:  // 입력한 텍스트 걸기 모드
//            print("displayMode")
//            self.customTextField.removeFromSuperview()
//            self.customTextField.resignFirstResponder()
//        }
//
//    }
    @IBAction func toggleARSwitch(_ sender: UISwitch) {
        if sender.isOn {
            
        } else {
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        
        textField.resignFirstResponder()
        textField.text = ""
        
        return true
    }
    
//    func makeTextToObject() {
//        // 텍스트를 3D 상자 오브젝트에 넣어주자.
//
//        let plane = SCNNode(geometry: SCNPlane(width: 0.1, height: 0.1))
//        plane.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//        plane.position = SCNVector3(0, 0, -0.3)
//        plane.eulerAngles = SCNVector3(Float(-90.degreesToRadian), 0, 0)
//        self.sceneView.scene.rootNode.addChildNode(plane)
//    }
    
    func getTextObjectContents() {
        uploadTextModel.setUploadContents() // 입력받은 텍스트와 좌표를 여기에 넣어줌. 파라미터 있는 놈으로 넣어주자.
    }
    
//    func addInputView() {
//
//    }
//
//    enum TextScreenMode {
//        case inputMode
//        case displayMode
//    }
}

extension Int {
    var degreesToRadian: Double { return Double(self) * .pi / 180 }
}
