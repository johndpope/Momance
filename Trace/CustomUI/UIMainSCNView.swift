//
//  UIMainView.swift
//  Trace
//
//  Created by Minki on 2017. 10. 27..
//  Copyright © 2017년 Shifter. All rights reserved.
//

import UIKit

class UIMainSCNView: UIView {
    
    @IBOutlet weak var textButton: ARBlueBottomButton!
    @IBOutlet weak var imageButton: ARBlueBottomButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
}
