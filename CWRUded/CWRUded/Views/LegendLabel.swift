//
//  LegendLabel.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 4/9/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit

class LegendLabel: UIView {
    public static let height: CGFloat = 20;
    private static let padding: CGFloat = 5;
    
    private let icon: UIView
    private let title: UILabel
    
    private let iconDiameter: CGFloat
    private let titleSize: CGSize
    public var expectedWidth: CGFloat
    
    init(text: String, color: UIColor) {
        icon = UIView()
        title = UILabel()
        
        iconDiameter = 10
        titleSize = text.size(withAttributes:[.font: UIFont.systemFont(ofSize: 16.0)])
        expectedWidth = iconDiameter + LegendLabel.padding + titleSize.width
        
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.layer.cornerRadius = iconDiameter / 2;
        icon.clipsToBounds = true
        icon.backgroundColor = color
        
        icon.addConstraint(NSLayoutConstraint(item: icon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: iconDiameter))
        icon.addConstraint(NSLayoutConstraint(item: icon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: iconDiameter))
        
        title.font = Fonts.app(size: 16)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.baselineAdjustment = .alignCenters
        title.textAlignment = .left
        title.text = text
        
        title.addConstraint(NSLayoutConstraint(item: title, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: titleSize.width + 5))
        title.addConstraint(NSLayoutConstraint(item: title, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: titleSize.height))
        
        addSubview(icon)
        addSubview(title)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: iconDiameter + LegendLabel.padding + titleSize.width))
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: LegendLabel.height))
        addConstraint(NSLayoutConstraint(item: icon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: title, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: title, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: iconDiameter + LegendLabel.padding))
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}
