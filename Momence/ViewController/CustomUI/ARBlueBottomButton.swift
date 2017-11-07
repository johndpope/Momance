//
//  ARBlueBottomButton.swift
//  Trace
//
//  Created by Minki on 2017. 10. 22..
//  Copyright © 2017년 Shifter. All rights reserved.
//

import UIKit

class ARBlueBottomButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
    }
}

protocol ARBlueBottomButtonDelegate {
    
    func onClick(_ sender: ARBlueBottomButton)
}
