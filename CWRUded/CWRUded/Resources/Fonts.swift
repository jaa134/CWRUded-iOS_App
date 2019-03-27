//
//  Fonts.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/27/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit

class Fonts {
    static func app(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
    static func fontAwesome(size: CGFloat) -> UIFont {
        return UIFont(name: "FontAwesome5Free-Solid", size: size)!
    }
}
