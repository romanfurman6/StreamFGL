//
//  Setting.swift
//  StreamFGL
//
//  Created by Roman Furman on 7/3/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import Foundation

struct Setting {
    let description: String
}

extension Setting: Equatable {
    static func ==(lhs: Setting, rhs: Setting) -> Bool {
        return lhs.description == rhs.description
    }
}
