//
//  UploadText.swift
//  Trace
//
//  Created by Minki on 2017. 10. 19..
//  Copyright © 2017년 Shifter. All rights reserved.
//

import Foundation

class UploadTextModel {
    
    func setUploadContents(x: Float, y: Float, z: Float, orientationX: Float, orientationY: Float, orientationZ: Float, text: String, list: inout [TextVO]) {  // TextVO를 세팅하는 메소드
        list.append(TextVO(x: x, y: y, z: z, orientationX: orientationX, orientationY: orientationY, orientationZ: orientationZ, textContent: text))
    }
    
    func sendDataToServer() {
        
    }
}
