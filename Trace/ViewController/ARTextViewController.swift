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
    //    @IBOutlet var realTextField: UITextField!
//
//    let customTextField = UITextField()
    let configuration = ARWorldTrackingConfiguration()
    
//    var screenMode = TextScreenMode.inputMode
    
    var uploadTextModel = UploadTextModel()
    
    // 텍스트 입력해서 걸어놓을 준비 중 일때 true
    var isReadyToHangTheObject = false
    var textContent: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.delegate = self
        self.sceneView.autoenablesDefaultLighting = true
        
        self.depthSlider.isEnabled = false  // 맨첨에 슬라이더 못만지게
        self.depthSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))    // slider바 세로로 세우기.
        self.objTextField.delegate = self
        self.objTextField.becomeFirstResponder()    // 초기 선택
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
        
        self.depthSlider.isEnabled = true
        self.isReadyToHangTheObject = true
        self.textContent = textField.text!
        textField.isHidden = true
        textField.resignFirstResponder()
        textField.text = ""
        
        let tNode = SCNText(string: textContent, extrusionDepth: 1)
        tNode.alignmentMode = "center"
        tNode.font = UIFont(name: "Gulim", size: 14)
        tNode.chamferRadius = 0.01/2
        let textNode = SCNNode(geometry: tNode)
        textNode.scale = SCNVector3(0.005, 0.005, 0.005)
        let defaultPosition = SCNVector3(-0.14, -0.08, -0.6)
        textNode.position = defaultPosition
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
    
    func getTextObjectContents() {
        uploadTextModel.setUploadContents() // 입력받은 텍스트와 좌표를 여기에 넣어줌. 파라미터 있는 놈으로 넣어주자.
    }
}

extension Int {
    var degreesToRadian: Double { return Double(self) * .pi / 180 }
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
}
