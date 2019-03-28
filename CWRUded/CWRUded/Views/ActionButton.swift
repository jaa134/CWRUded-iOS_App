//
//  ActionButton.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/27/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit

class ActionButton : UIView {
    private let text: String
    private let textFont: UIFont
    private let icon: String
    private let iconFont: UIFont
    private let bgColor: UIColor
    private let fgColor: UIColor
    private let action: () -> ()
    
    init(text: String,
         textFont: UIFont,
         icon: String,
         iconFont: UIFont,
         backgroundColor: UIColor,
         foregroundColor: UIColor,
         frame: CGRect,
         action: @escaping () -> ()) {
        self.text = text
        self.textFont = textFont
        self.icon = icon
        self.iconFont = iconFont
        self.bgColor = backgroundColor
        self.fgColor = foregroundColor
        self.action = action
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    private func setupView() {
        setBackground()
        placeContent()
        addPressGesture()
    }
    
    private func setBackground() {
        backgroundColor = bgColor
        layer.cornerRadius = 5
        clipsToBounds = true
        isUserInteractionEnabled = true
    }
    
    private func textLabel() -> UILabel {
        let textLabel = UILabel()
        textLabel.isUserInteractionEnabled = true
        textLabel.text = text
        textLabel.font = textFont
        textLabel.textColor = fgColor
        textLabel.numberOfLines = 1
        textLabel.sizeToFit()
        return textLabel
    }
    
    private func iconLabel() -> UILabel {
        let iconLabel = UILabel()
        iconLabel.isUserInteractionEnabled = true
        iconLabel.text = icon
        iconLabel.font = iconFont
        iconLabel.textColor = fgColor
        iconLabel.numberOfLines = 1
        iconLabel.sizeToFit()
        return iconLabel
    }
    
    private func containerView() -> UIView {
        let containerView = UIView()
        containerView.isUserInteractionEnabled = true
        return containerView
    }
    
    private func placeContent() {
        let containerView = self.containerView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        let containerHorizontalConstraint = NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let containerVerticalConstraint = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        addConstraints([containerHorizontalConstraint, containerVerticalConstraint])
        
        let iconLabel = self.iconLabel()
        let textLabel = self.textLabel()
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconLabel)
        containerView.addSubview(textLabel)
        
        let iconLeadingConstraint = NSLayoutConstraint(item: iconLabel, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0)
        let iconVerticalConstraint = NSLayoutConstraint(item: iconLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0)
        let iconWidthConstraint = NSLayoutConstraint(item: iconLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: iconLabel.frame.width)
        let iconHeightConstraint = NSLayoutConstraint(item: iconLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: iconLabel.frame.height)
        
        let textTrailingConstraint = NSLayoutConstraint(item: textLabel, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0)
        let textVerticalConstraint = NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0)
        let textWidthConstraint = NSLayoutConstraint(item: textLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: textLabel.frame.width)
        let textHeightConstraint = NSLayoutConstraint(item: textLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: textLabel.frame.height)
        
        let horizontalConstraint = NSLayoutConstraint(item: textLabel, attribute: .leading, relatedBy: .equal, toItem: iconLabel, attribute: .trailing, multiplier: 1, constant: 10)
        
        containerView.addConstraints([iconLeadingConstraint,
                                      iconVerticalConstraint,
                                      iconWidthConstraint,
                                      iconHeightConstraint,
                                      textTrailingConstraint,
                                      textVerticalConstraint,
                                      textWidthConstraint,
                                      textHeightConstraint,
                                      horizontalConstraint])
    }
    
    private func addPressGesture() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapped))
        tap.minimumPressDuration = 0
        addGestureRecognizer(tap)
    }
    
    @objc func tapped(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            onPress()
        } else if  gesture.state == .ended {
            onRelease(tapPoint: gesture.location(in: self))
        }
    }
    
    private func onPress() {
        UIView.animate(withDuration: 0.05, animations: {
            self.subviews.forEach({ $0.layer.opacity = 0.5 })
        })
    }
    
    private func onRelease(tapPoint: CGPoint) {
        UIView.animate(withDuration: 0.05, animations: {
            self.subviews.forEach({ $0.layer.opacity = 1 })
        })
        
        if (self.bounds.contains(tapPoint)) {
            action()
        }
    }
}
