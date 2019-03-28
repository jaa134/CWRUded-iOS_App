//
//  LocationView.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/20/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit

class CongestionBar : UIView {
    public static let height: CGFloat = 12;
    private static let greenColor: [CGFloat] = [51.0, 165.0, 50.0]
    private static let yellowColor: [CGFloat] = [250.0, 220.0, 22.0]
    private static let redColor: [CGFloat] = [204.0, 50.0, 50.0]
    
    private var rating: Int
    private var colorView: UIView
    
    fileprivate init(x: CGFloat, y: CGFloat, width: CGFloat, rating: Int) {
        self.rating = max(1, min(rating, 100))
        self.colorView = UIView()
        super.init(frame: CGRect(x: x, y: y, width: width, height: CongestionBar.height))
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
        layer.cornerRadius = CongestionBar.height / 2
        clipsToBounds = true
    }
    
    private func getMaskColor() -> UIColor {
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        
        let step: CGFloat
        if (rating <= 50) {
            step = CGFloat(rating) / 50.0
            r = (CongestionBar.greenColor[0] + ((CongestionBar.yellowColor[0] - CongestionBar.greenColor[0]) * step)) / 255.0
            g = (CongestionBar.greenColor[1] + ((CongestionBar.yellowColor[1] - CongestionBar.greenColor[1]) * step)) / 255.0
            b = (CongestionBar.greenColor[2] + ((CongestionBar.yellowColor[2] - CongestionBar.greenColor[2]) * step)) / 255.0
        }
        else {
            step = CGFloat(rating - 50) / 50.0
            r = (CongestionBar.yellowColor[0] + ((CongestionBar.redColor[0] - CongestionBar.yellowColor[0]) * step)) / 255.0
            g = (CongestionBar.yellowColor[1] + ((CongestionBar.redColor[1] - CongestionBar.yellowColor[1]) * step)) / 255.0
            b = (CongestionBar.yellowColor[2] + ((CongestionBar.redColor[2] - CongestionBar.yellowColor[2]) * step)) / 255.0
        }
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    private func getColorViewRect() -> CGRect {
        return CGRect(x: 0, y: 0, width: (frame.width * CGFloat(rating) / 100), height: CongestionBar.height)
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



class SpaceInfo : UIView {
    public static let padding_v: CGFloat = 5;
    public static let padding_h: CGFloat = 10;
    public static let titleBarHeight: CGFloat = 25;
    
    fileprivate let space: Space
    private var congestionView: CongestionBar?
    
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
        
        let width: CGFloat = screenWidth - (2 * LocationInfo.padding_h) - (2 * SpaceInfo.padding_h)
        let height: CGFloat = 50
        frame = CGRect(x: SpaceInfo.padding_h, y: 0, width: width, height: height)
    }
    
    private func setColor() {
        backgroundColor = ColorPallete.transparent
    }
    
    private func setTitle() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: SpaceInfo.titleBarHeight))
        titleLabel.font = Fonts.app(size: 22)
        titleLabel.text = space.name
        titleLabel.textColor = ColorPallete.white
        addSubview(titleLabel)
    }
    
    private func placeProgressView() {
        congestionView = CongestionBar(x: 0, y: SpaceInfo.titleBarHeight + 3, width: frame.width, rating: space.congestionRating)
        addSubview(congestionView!)
    }
    
    fileprivate func update(space: Space) {
        congestionView!.update(rating: space.congestionRating)
    }
}



class LocationInfo : UIView {
    public static let padding_v: CGFloat = 10;
    public static let padding_h: CGFloat = 10;
    public static let titleBarHeight: CGFloat = 40;
    
    fileprivate let location: Location
    private var spaceViews: [SpaceInfo]
    
    init(location: Location) {
        self.location = location
        spaceViews = [SpaceInfo]()
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
            spaceViews.append(SpaceInfo(space: space))
        }
    }
    
    private func calcHeight() -> CGFloat {
        var height: CGFloat = LocationInfo.titleBarHeight
        for spaceView in spaceViews {
            height += spaceView.frame.height
        }
        height += CGFloat(spaceViews.count + 1) * SpaceInfo.padding_v
        return height + (2 * SpaceInfo.padding_v)
    }
    
    private func setSize() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let width: CGFloat = screenWidth - (2 * LocationInfo.padding_h)
        let height: CGFloat = calcHeight()
        frame = CGRect(x: LocationInfo.padding_h, y: 0, width: width, height: height)
    }
    
    private func setColor() {
        backgroundColor = ColorPallete.navyBlue
    }
    
    private func roundCorners() {
        layer.cornerRadius = 6
        clipsToBounds = true
    }
    
    private func setIcon() {
        let iconLabel = UILabel(frame: CGRect(x: SpaceInfo.padding_h, y: 7, width: 50, height: LocationInfo.titleBarHeight))
        iconLabel.font = Fonts.fontAwesome(size: 30)
        iconLabel.text = Icons.from(type: location.type)
        iconLabel.textColor = ColorPallete.white
        addSubview(iconLabel)
    }
    
    private func setTitle() {
        let titleLabel = UILabel(frame: CGRect(x: 60, y: 7, width: frame.width - 60 - SpaceInfo.padding_h, height: LocationInfo.titleBarHeight))
        titleLabel.font = Fonts.app(size: 30, weight: .medium)
        titleLabel.text = location.name
        titleLabel.textColor = ColorPallete.white
        addSubview(titleLabel)
    }
    
    private func placeChildViews() {
        var height: CGFloat = LocationInfo.titleBarHeight + (2 * SpaceInfo.padding_v)
        for spaceView in spaceViews {
            spaceView.frame.origin.y = height
            addSubview(spaceView)
            height += spaceView.frame.height + SpaceInfo.padding_v
        }
    }
    
    public func update(location: Location) {
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
