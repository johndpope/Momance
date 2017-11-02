//
//  UIImageSCNView.swift
//  Trace
//
//  Created by Minki on 2017. 10. 27..
//  Copyright © 2017년 Shifter. All rights reserved.
//

import UIKit

class UIImageSCNView: UIView {

    @IBOutlet weak var postButton: ARBlueBottomButton!
    @IBOutlet weak var cancelButton: ARBlueBottomButton!
    @IBOutlet weak var depthSlider: UISlider!
    
    @IBOutlet weak var selectOptionView: UIView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var turnCameraButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

}
