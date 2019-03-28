//
//  LocationsTable.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/27/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit

class LocationCell : UIView {
    public static let padding_h: CGFloat = 10;
    public static let height: CGFloat = 50;
    
    private let onCellTapped: (LocationCell) ->()
    public let location: Location
    
    init(location: Location, onCellTapped: @escaping (LocationCell) ->()) {
        self.onCellTapped = onCellTapped
        self.location = location
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    private func setupView() {
        setOptions()
        setSize()
        setColor()
        setBorderBottom()
        setIcon()
        setTitle()
        setSpaceCount()
        setNavArrow()
        addPressGesture()
    }
    
    private func setOptions() {
        isHidden = false
        isUserInteractionEnabled = true
    }
    
    private func setSize() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let width: CGFloat = screenWidth
        let height: CGFloat = LocationCell.height
        frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    private func setColor() {
        backgroundColor = ColorPallete.clay
    }
    
    private func setBorderBottom() {
        let border = CALayer()
        border.backgroundColor = ColorPallete.grey.cgColor
        border.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        layer.addSublayer(border)
    }
    
    private func setIcon() {
        let iconLabel = UILabel()
        iconLabel.font = Fonts.fontAwesome(size: 20)
        iconLabel.text = Icons.from(type: location.type)
        iconLabel.textAlignment = .center
        iconLabel.textColor = ColorPallete.grey
        iconLabel.baselineAdjustment = .alignCenters
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconLabel)
        iconLabel.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25))
        iconLabel.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15))
        addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    private func setTitle() {
        let titleLabel = UILabel()
        titleLabel.font = Fonts.app(size: 20, weight: .regular)
        titleLabel.text = location.name
        titleLabel.textColor = ColorPallete.black
        titleLabel.baselineAdjustment = .alignCenters
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        titleLabel.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.width - 80))
        titleLabel.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 22))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -25))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5))
    }
    
    private func setSpaceCount() {
        let countLabel = UILabel()
        countLabel.font = Fonts.app(size: 15, weight: .regular)
        countLabel.text = location.displayCount
        countLabel.textColor = ColorPallete.black
        countLabel.baselineAdjustment = .alignCenters
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(countLabel)
        countLabel.addConstraint(NSLayoutConstraint(item: countLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frame.width - 80))
        countLabel.addConstraint(NSLayoutConstraint(item: countLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 17))
        addConstraint(NSLayoutConstraint(item: countLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -25))
        addConstraint(NSLayoutConstraint(item: countLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -5))
    }
    
    private func setNavArrow() {
        let iconLabel = UILabel()
        iconLabel.font = Fonts.fontAwesome(size: 12)
        iconLabel.text = Icons.arrow
        iconLabel.textAlignment = .center
        iconLabel.textColor = ColorPallete.darkGrey
        iconLabel.baselineAdjustment = .alignCenters
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconLabel)
        iconLabel.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 6))
        iconLabel.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12))
        addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15))
        addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    private func addPressGesture() {
        //let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapped))
        //tap.minimumPressDuration = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
    }
    
    @objc private func tapped(gesture: UITapGestureRecognizer) {
        
        if gesture.state == .began {
            onPress()
        } else if  gesture.state == .ended {
            onRelease()
        }
    }
    
    private func onPress() {
        UIView.animate(withDuration: 0.05, animations: {
            self.subviews.forEach({ $0.layer.opacity = 0.5 })
        })
    }
    
    private func onRelease() {
        UIView.animate(withDuration: 0.05, animations: {
            self.subviews.forEach({ $0.layer.opacity = 1 })
        })
        onCellTapped(self)
    }
}


class LocationsTable : UIView {
    private var locationCells: [LocationCell]
    
    init(onCellTapped: @escaping (LocationCell) -> ()) {
        self.locationCells = [LocationCell]()
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setupView(onCellTapped: onCellTapped)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    private func setupView(onCellTapped: @escaping (LocationCell) ->()) {
        setOptions()
        createChildViews(onCellTapped: onCellTapped)
        setSize()
        setColor()
        placeChildViews()
    }
    
    private func setOptions() {
        isHidden = false
        isUserInteractionEnabled = true
    }
    
    private func createChildViews(onCellTapped: @escaping (LocationCell) ->()) {
        for location in CrowdedData.singleton.locations {
            locationCells.append(LocationCell(location: location, onCellTapped: onCellTapped))
        }
    }
    
    private func calcHeight() -> CGFloat {
        var height: CGFloat = 0
        for locationCell in locationCells {
            if (!locationCell.isHidden) {
                height += locationCell.frame.height
            }
        }
        return height
    }
    
    private func setSize() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let height: CGFloat = calcHeight()
        let width: CGFloat = screenWidth
        frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    private func setColor() {
        backgroundColor = ColorPallete.transparent
    }
    
    private func placeChildViews() {
        var height: CGFloat = 0
        for locationCell in locationCells {
            if (!locationCell.isHidden) {
                locationCell.frame.origin.y = height
                addSubview(locationCell)
                height += locationCell.frame.height
            }
        }
    }
    
    public func filter(filter: Type?) {
        for locationCell in locationCells {
            locationCell.isHidden = filter != nil && locationCell.location.type != filter
        }
        setSize()
        placeChildViews()
    }
}
