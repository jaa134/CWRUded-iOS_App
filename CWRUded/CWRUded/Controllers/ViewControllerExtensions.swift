//
//  ViewControllerExtensions.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/26/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public func setTitle(container: UIView, iconLabel: UILabel, textLabel: UILabel, icon: String, title: String) {
        container.backgroundColor = ColorPallete.white
        container.layer.masksToBounds = false
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.5
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 1
        var rect = container.bounds
        rect.size.width = UIScreen.main.bounds.width
        container.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        container.layer.shouldRasterize = true
        container.layer.rasterizationScale = UIScreen.main.scale
        container.layer.zPosition = 1000
        
        iconLabel.backgroundColor = ColorPallete.navyBlue
        iconLabel.layer.cornerRadius = 0.5 * iconLabel.bounds.size.width
        iconLabel.clipsToBounds = true
        iconLabel.font = Fonts.fontAwesome(size: 35)
        iconLabel.text = icon
        iconLabel.textColor = ColorPallete.white
        
        textLabel.text = title
        textLabel.backgroundColor = ColorPallete.grey
        textLabel.layer.cornerRadius = 5
        textLabel.clipsToBounds = true
        textLabel.textColor = ColorPallete.white
    }
}
