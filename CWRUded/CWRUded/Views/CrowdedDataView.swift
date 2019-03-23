//
//  LocationView.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/20/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit

class CongestionView : UIView {
    public static let height: CGFloat = 16;
    private static let greenColor: [CGFloat] = [51.0, 165.0, 50.0]
    private static let yellowColor: [CGFloat] = [250.0, 220.0, 22.0]
    private static let redColor: [CGFloat] = [204.0, 50.0, 50.0]
    
    private var rating: Int
    private var colorView: UIView
    
    fileprivate init(x: CGFloat, y: CGFloat, width: CGFloat, rating: Int) {
        self.rating = max(1, min(rating, 100))
        self.colorView = UIView()
        super.init(frame: CGRect(x: x, y: y, width: width, height: CongestionView.height))
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    private func setupView() {
        setOptions()
        setColor()
        roundCorners()
        addColorView()
    }
    
    private func setOptions() {
        isHidden = false
        isOpaque = false
        isUserInteractionEnabled = false
    }
    
    private func setColor() {
        backgroundColor = ColorPallete.white
    }
    
    private func roundCorners() {
        layer.cornerRadius = CongestionView.height / 2
        clipsToBounds = true
    }
    
    private func getMaskColor() -> UIColor {
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        
        let step: CGFloat
        if (rating <= 50) {
            step = CGFloat(rating) / 50.0
            r = (CongestionView.greenColor[0] + ((CongestionView.yellowColor[0] - CongestionView.greenColor[0]) * step)) / 255.0
            g = (CongestionView.greenColor[1] + ((CongestionView.yellowColor[1] - CongestionView.greenColor[1]) * step)) / 255.0
            b = (CongestionView.greenColor[2] + ((CongestionView.yellowColor[2] - CongestionView.greenColor[2]) * step)) / 255.0
        }
        else {
            step = CGFloat(rating - 50) / 50.0
            r = (CongestionView.yellowColor[0] + ((CongestionView.redColor[0] - CongestionView.yellowColor[0]) * step)) / 255.0
            g = (CongestionView.yellowColor[1] + ((CongestionView.redColor[1] - CongestionView.yellowColor[1]) * step)) / 255.0
            b = (CongestionView.yellowColor[2] + ((CongestionView.redColor[2] - CongestionView.yellowColor[2]) * step)) / 255.0
        }
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    private func getColorViewRect() -> CGRect {
        return CGRect(x: 0, y: 0, width: (frame.width * CGFloat(rating) / 100), height: CongestionView.height)
    }
    
    private func addColorView() {
        colorView.isHidden = false
        colorView.isOpaque = false
        colorView.isUserInteractionEnabled = false
        colorView.frame = getColorViewRect()
        colorView.backgroundColor = getMaskColor()
        
        addSubview(colorView)
    }
    
    fileprivate func update(rating: Int) {
        self.rating = rating
        UIView.animate(withDuration: 0.15,
                       animations: {
                        self.colorView.frame = self.getColorViewRect()
                        self.colorView.backgroundColor = self.getMaskColor()
        })
    }
}



class SpaceView : UIView {
    public static let padding_v: CGFloat = 5;
    public static let padding_h: CGFloat = 10;
    public static let titleBarHeight: CGFloat = 25;
    
    fileprivate let space: Space
    private var congestionView: CongestionView?
    
    fileprivate init(space: Space) {
        self.space = space
        self.congestionView = nil
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
        setTitle()
        placeProgressView()
    }
    
    private func setOptions() {
        isHidden = false
        isUserInteractionEnabled = false
    }
    
    private func setSize() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let width: CGFloat = screenWidth - (2 * LocationView.padding_h) - (2 * SpaceView.padding_h)
        let height: CGFloat = 50
        frame = CGRect(x: SpaceView.padding_h, y: 0, width: width, height: height)
    }
    
    private func setColor() {
        backgroundColor = ColorPallete.transparent
    }
    
    private func setTitle() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: SpaceView.titleBarHeight))
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        titleLabel.text = space.name
        titleLabel.textColor = ColorPallete.white
        addSubview(titleLabel)
    }
    
    private func placeProgressView() {
        congestionView = CongestionView(x: 0, y: SpaceView.titleBarHeight + 3, width: frame.width, rating: space.congestionRating)
        addSubview(congestionView!)
    }
    
    fileprivate func update(space: Space) {
        congestionView!.update(rating: space.congestionRating)
    }
}



class LocationView : UIView {
    public static let padding_v: CGFloat = 10;
    public static let padding_h: CGFloat = 10;
    public static let titleBarHeight: CGFloat = 40;
    
    fileprivate let location: Location
    private var spaceViews: [SpaceView]
    
    fileprivate init(location: Location) {
        self.location = location
        spaceViews = [SpaceView]()
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    private func setupView() {
        setOptions()
        createChildViews()
        setSize()
        setColor()
        roundCorners()
        setIcon()
        setTitle()
        placeChildViews()
    }
    
    private func setOptions() {
        isHidden = false
        isUserInteractionEnabled = false
    }
    
    private func createChildViews() {
        for space in location.spaces {
            spaceViews.append(SpaceView(space: space))
        }
    }
    
    private func calcHeight() -> CGFloat {
        var height: CGFloat = LocationView.titleBarHeight
        for spaceView in spaceViews {
            height += spaceView.frame.height
        }
        height += CGFloat(spaceViews.count + 1) * SpaceView.padding_v
        return height + (2 * SpaceView.padding_v)
    }
    
    private func setSize() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let width: CGFloat = screenWidth - (2 * LocationView.padding_h)
        let height: CGFloat = calcHeight()
        frame = CGRect(x: LocationView.padding_h, y: 0, width: width, height: height)
    }
    
    private func setColor() {
        backgroundColor = ColorPallete.navyBlue
    }
    
    private func roundCorners() {
        layer.cornerRadius = 6
        clipsToBounds = true
    }
    
    private func getIcon() -> String {
        switch location.type {
        case .academic: return "\u{f02d}"
        case .dining:   return "\u{f2e7}"
        case .gym:      return "\u{f44b}"
        }
    }
    
    private func setIcon() {
        let iconLabel = UILabel(frame: CGRect(x: SpaceView.padding_h, y: 7, width: 50, height: LocationView.titleBarHeight))
        iconLabel.font = UIFont(name: "FontAwesome5Free-Solid", size: 30)
        iconLabel.text = getIcon()
        iconLabel.textColor = ColorPallete.white
        addSubview(iconLabel)
    }
    
    private func setTitle() {
        let titleLabel = UILabel(frame: CGRect(x: 60, y: 7, width: frame.width - 60 - SpaceView.padding_h, height: LocationView.titleBarHeight))
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        titleLabel.text = location.name
        titleLabel.textColor = ColorPallete.white
        addSubview(titleLabel)
    }
    
    private func placeChildViews() {
        var height: CGFloat = LocationView.titleBarHeight + (2 * SpaceView.padding_v)
        for spaceView in spaceViews {
            spaceView.frame.origin.y = height
            addSubview(spaceView)
            height += spaceView.frame.height + SpaceView.padding_v
        }
    }
    
    fileprivate func update(location: Location) {
        for space in location.spaces {
            for spaceView in spaceViews {
                if (spaceView.space.id == space.id) {
                    spaceView.update(space: space)
                    break
                }
            }
        }
    }
}



class CrowdedDataView : UIView {
    private var locationViews: [LocationView]
    
    init() {
        locationViews = [LocationView]()
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let parent = superview as? UIScrollView {
            let screensize: CGRect = UIScreen.main.bounds
            let scrollWidth: CGFloat = screensize.width
            let scrollHeight: CGFloat = frame.height
            parent.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        }
    }
    
    private func setupView() {
        setOptions()
        createChildViews()
        setSize()
        setColor()
        placeChildViews()
    }
    
    private func setOptions() {
        isHidden = false
        isUserInteractionEnabled = false
    }
    
    private func createChildViews() {
        for location in CrowdedData.singleton.filteredLocations {
            locationViews.append(LocationView(location: location))
        }
    }
    
    private func calcHeight() -> CGFloat {
        var height: CGFloat = 0
        for locationView in locationViews {
            height += locationView.frame.height
        }
        height += CGFloat(locationViews.count + 1) * LocationView.padding_v
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
        var height: CGFloat = LocationView.padding_v
        for locationView in locationViews {
            locationView.frame.origin.y = height
            addSubview(locationView)
            height += locationView.frame.height + LocationView.padding_v
        }
    }
    
    public func update() {
        for location in CrowdedData.singleton.locations {
            for locationView in locationViews {
                if (locationView.location.id == location.id) {
                    locationView.update(location: location)
                    break
                }
            }
        }
    }
}
