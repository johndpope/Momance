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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        /// myPage로 이동하기
        
        myPageBarButton.target = self
        myPageBarButton.action = #selector(movePage(_:))
        /// navigationbar 투명하게 만들기 (2줄)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        decorateButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.sceneView.session.run(AppDelegate.configuration)
        
        /// navigationbar 투명하게 만들기 (1줄)
        self.navigationController?.navigationBar.isTranslucent = true
        
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
    
    func decorateButtons() {
        
        self.moveTextVCBtn.layer.cornerRadius = 20
        self.moveTextVCBtn.layer.borderWidth = 2
        self.moveTextVCBtn.layer.borderColor = UIColor.white.cgColor
        
        self.moveImageVCBtn.layer.cornerRadius = 20
        self.moveImageVCBtn.layer.borderWidth = 2
        self.moveImageVCBtn.layer.borderColor = UIColor.white.cgColor
    }
}

