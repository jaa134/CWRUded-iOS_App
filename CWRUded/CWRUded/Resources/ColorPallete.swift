//
//  ColorPallete.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/21/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import UIKit

class ColorPallete {
    static let transparent = UIColor(white: 1, alpha: 0)
    static let white = UIColor.white
    static let black = UIColor.black
    static let navyBlue = UIColor(red: 10/255.0, green: 48/255.0, blue: 78/255.0, alpha: 1)
    static let grey = UIColor(red: 130/255.0, green: 130/255.0, blue: 130/255.0, alpha: 1)
    static let darkGrey = UIColor(red: 100/255.0, green: 100/255.0, blue: 100/255.0, alpha: 1)
    static let clay = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
    static let red = UIColor(red: 227/255.0, green: 27/255.0, blue: 35/255.0, alpha: 1)
    static let green = UIColor(red: 50/255.0, green: 205/255.0, blue: 50/255.0, alpha: 1)
    static let lightBlue = UIColor(red: 30/255.0, green: 150/255.0, blue: 210/255.0, alpha: 1)
    
    private static let congestion_g: [CGFloat] = [91.0, 194.0, 54.0]
    private static let congestion_y: [CGFloat] = [250.0, 220.0, 22.0]
    private static let congestion_r: [CGFloat] = [227.0, 27.0, 35.0]
    
    public static let chartLineColors = [UIColor.red,
                                          UIColor.blue,
                                          UIColor.green,
                                          UIColor.cyan,
                                          UIColor.yellow,
                                          UIColor.purple,
                                          UIColor.magenta,
                                          UIColor.orange,
                                          UIColor.gray,
                                          UIColor.brown]
    
    public static func congestionColor(min: CGFloat, max: CGFloat, current: CGFloat) -> UIColor {
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        
        let step: CGFloat
        if (current <= ((max - min) / 2)) {
            step = current / 50
            r = (ColorPallete.congestion_g[0] + ((ColorPallete.congestion_y[0] - ColorPallete.congestion_g[0]) * step)) / 255.0
            g = (ColorPallete.congestion_g[1] + ((ColorPallete.congestion_y[1] - ColorPallete.congestion_g[1]) * step)) / 255.0
            b = (ColorPallete.congestion_g[2] + ((ColorPallete.congestion_y[2] - ColorPallete.congestion_g[2]) * step)) / 255.0
        }
        else {
            step = (current - 50) / 50
            r = (ColorPallete.congestion_y[0] + ((ColorPallete.congestion_r[0] - ColorPallete.congestion_y[0]) * step)) / 255.0
            g = (ColorPallete.congestion_y[1] + ((ColorPallete.congestion_r[1] - ColorPallete.congestion_y[1]) * step)) / 255.0
            b = (ColorPallete.congestion_y[2] + ((ColorPallete.congestion_r[2] - ColorPallete.congestion_y[2]) * step)) / 255.0
        }
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
