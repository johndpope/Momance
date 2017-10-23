//
//  ViewController.swift
//  Trace
//
//  Created by Minki on 2017. 10. 16..
//  Copyright © 2017년 Shifter. All rights reserved.
//

import UIKit
import ARKit
class ARSceneViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    var naviColor: UIColor?
    @IBOutlet weak var myPageBarButton: UIBarButtonItem!
    
    @IBOutlet weak var moveTextVCBtn: UIButton!
    @IBOutlet weak var moveImageVCBtn: UIButton!
    var textContentsList = [TextVO]()
    let initScale = SCNVector3(0.005, 0.005, 0.005)
    let defaultPosition = SCNVector3(-0.14, -0.08, -0.6)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        /// myPage로 이동하기
        
        myPageBarButton.target = self
        myPageBarButton.action = #selector(movePage(_:))
        /// navigationbar 투명하게 만들기 (2줄)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.sceneView.session.run(AppDelegate.configuration)
        
        /// navigationbar 투명하게 만들기 (1줄)
        self.navigationController?.navigationBar.isTranslucent = true
        
        for obj in textContentsList {
            self.sceneView.scene.rootNode.addChildNode(createNode(nodeOption: obj))
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
    
    override func viewWillDisappear(_ animated: Bool) {
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
        print("unwind됨~!")
        let vc = segue.source as! ARTextViewController
        if let textNode = vc.realTextNode, let textContent = vc.textContent {
            textContentsList.append(TextVO(x: textNode.worldPosition.x, y: textNode.worldPosition.y, z: textNode.worldPosition.z, textContent: textContent))
//            TextVO(x: <#T##Float?#>, y: <#T##Float?#>, z: <#T##Float?#>, textContent: <#T##String?#>, red: <#T##Float?#>, green: <#T##Float?#>, blue: <#T##Float?#>)
            
            
        }
    }
}

