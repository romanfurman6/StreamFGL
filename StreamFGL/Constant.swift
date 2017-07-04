//
//  Constant.swift
//  StreamFGL
//
//  Created by Roman Furman on 6/29/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import Foundation

class Constant {
    static let shared = Constant()
    let streamURL = "rtmp://media2.focusgrouplive.com/live"
    let fglURL = "http://focusgrouplive.com"
}

class Color {
    static let micOnColor = UIColor(red: 0.0/255.0, green: 198.0/255.0, blue: 124.0/255.0, alpha: 1.0)
    static let micOffColor = UIColor(red: 198.0/255.0, green: 58.0/255.0, blue: 0, alpha: 1.0)
}
