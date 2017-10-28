//
//  UITextSCNView.swift
//  Trace
//
//  Created by Minki on 2017. 10. 27..
//  Copyright © 2017년 Shifter. All rights reserved.
//

import UIKit

class UITextSCNView: UIView {

    @IBOutlet weak var cancelButton: ARBlueBottomButton!
    @IBOutlet weak var postButton: ARBlueBottomButton!
    @IBOutlet weak var depthSlider: UISlider!
    @IBOutlet weak var objTextField: UITextField!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        commonInit()
    }

    @IBAction func onDepthValueChanged(_ sender: UISlider) {
        self.depthSlider.value = sender.value
        print("value in textscene:\(sender.value)")
    }
    // TOKNOW: xib를 Bundle.main.loadNibNamed로 불러오면 왜 IBOutlet으로 선언한 놈들이 nil이 되는거지? init?(coder) 여기를 거쳐감에도 불구하고?
    
}
