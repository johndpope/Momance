//
//  ARImageViewController.swift
//  Trace
//
//  Created by Minki on 2017. 10. 16..
//  Copyright © 2017년 Shifter. All rights reserved.
//

import UIKit
import ARKit

class ARImageViewController: UIViewController {
    
    let configuration = ARWorldTrackingConfiguration()
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
