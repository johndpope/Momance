//
//  TextObject.swift
//  Trace
//
//  Created by Minki on 2017. 10. 19..
//  Copyright © 2017년 Shifter. All rights reserved.
//

import Foundation
import UIKit

public struct TextVO {
    
    var x: Float?
    var y: Float?
    var z: Float?
    var textContent: String?
//    var red: Float?
//    var green: Float?
//    var blue: Float?
    
    /// r, g, b값은 0~255값
    func textColor(r: Float, g: Float, b: Float) -> UIColor {
//        red = r
//        green = g
//        blue = b
        return UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: 1.0)
    }
    
    /// hex는 16진수 헥사값 (알파값 포함 가능)
    func textColor(hex: String) -> UIColor {
        return UIColor(named: hex) ?? UIColor(named: "#FFFFFF")!
    }
}
