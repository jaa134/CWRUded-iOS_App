//
//  AboutTableModelView.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/21/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit

class ArrowLabel : UILabel {
    public static let bottomInset: CGFloat = 8
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        textColor = ColorPallete.grey
        font = Fonts.fontAwesome(size: 20)
        text = Icons.triangle
        textAlignment = .center;
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 0, bottom: ArrowLabel.bottomInset, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
}



class AboutTableItemView : UIView {
    public static let padding_h: CGFloat = 10
    public static let padding_v: CGFloat = 10
    
    fileprivate var isCollapsed: Bool
    fileprivate let item: AboutTableItem
    fileprivate let arrowLabel: ArrowLabel
    private let titleLabel: UILabel
    private let contentLabel: UILabel
    
    fileprivate init(item: AboutTableItem) {
        self.isCollapsed = true
        self.item = item
        self.arrowLabel = ArrowLabel()
        self.titleLabel = UILabel()
        self.contentLabel = UILabel()
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addTapGesture()
    }
    
    private func setupView() {
        setOptions()
        setSize()
        roundCorners()
        setColor()
        placeComponents()
        resetHeight()
    }
    
    private func setOptions() {
        isHidden = false
        isUserInteractionEnabled = true
    }
    
    private func setSize() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let width: CGFloat = screenWidth - (2 * AboutTableItemView.padding_h)
        frame = CGRect(x: AboutTableItemView.padding_h, y: 0, width: width, height: 0)
    }
    
    private func roundCorners() {
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    private func setColor() {
        backgroundColor = ColorPallete.white
    }
    
    fileprivate func getTitleHeight() -> CGFloat {
        return titleLabel.frame.height + (2 * AboutTableItemView.padding_v)
    }
    
    fileprivate func getContentHeight() -> CGFloat {
        return contentLabel.frame.height + AboutTableItemView.padding_v
    }
    
    private func placeComponents() {
        arrowLabel.frame = CGRect(x: frame.width - (2.5 * AboutTableItemView.padding_h),
                                  y: AboutTableItemView.padding_v + ArrowLabel.bottomInset,
                                  width: 12,
                                  height: 15)
        arrowLabel.transform = CGAffineTransform(rotationAngle: -.pi/2)
        addSubview(arrowLabel)
        
        titleLabel.frame = CGRect(x: AboutTableItemView.padding_h,
                                  y: AboutTableItemView.padding_v,
                                  width: arrowLabel.frame.origin.x - (2 * AboutTableItemView.padding_h),
                                  height: 0)
        titleLabel.textColor = ColorPallete.black
        titleLabel.text = item.title
        titleLabel.font = Fonts.app(size: 25)
        titleLabel.isUserInteractionEnabled = true
        titleLabel.numberOfLines = 10
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        
        contentLabel.frame = CGRect(x: AboutTableItemView.padding_h,
                               y: getTitleHeight(),
                               width: frame.width - (2 * AboutTableItemView.padding_h),
                               height: 0)
        contentLabel.textColor = ColorPallete.black
        contentLabel.text = item.content
        contentLabel.font = Fonts.app(size: 16)
        contentLabel.isUserInteractionEnabled = true
        contentLabel.numberOfLines = 10
        contentLabel.sizeToFit()
        addSubview(contentLabel)
    }
    
    private func resetHeight() {
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: getTitleHeight())
    }
    
    private func addTapGesture() {
        var tap: UITapGestureRecognizer
        tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
    
    @objc private func tapped() {
        if let parent = superview as? AboutTableDataView {
            parent.toggleItem(itemView: self)
        }
    }
}



class AboutTableDataView : UIView {
    private var isAnimating: Bool
    private var itemViews: [AboutTableItemView]
    
    init() {
        self.isAnimating = false
        itemViews = [AboutTableItemView]()
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setParentSize()
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
        isUserInteractionEnabled = true
    }
    
    private func createChildViews() {
        for item in AboutTableData.singleton.items {
            itemViews.append(AboutTableItemView(item: item))
        }
        itemViews = itemViews.sorted(by: { $0.item.order < $1.item.order })
    }
    
    private func calcCurrentHeight() -> CGFloat {
        var height: CGFloat = 0
        for itemView in itemViews {
            height += itemView.frame.height
        }
        height += CGFloat(itemViews.count + 1) * AboutTableItemView.padding_v
        return height
    }
    
    private func setSize() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let height: CGFloat = calcCurrentHeight()
        let width: CGFloat = screenWidth
        frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    private func setParentSize() {
        if let parent = superview as? UIScrollView {
            let screensize: CGRect = UIScreen.main.bounds
            let scrollWidth: CGFloat = screensize.width
            let scrollHeight: CGFloat = frame.height
            parent.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        }
    }
    
    fileprivate func toggleItem(itemView: AboutTableItemView) {
        if (isAnimating) {
            return
        }
        
        if let parent = superview as? UIScrollView {
            if (itemView.isCollapsed) {
                expandItem(parentView: parent, itemView: itemView)
            }
            else {
                shrinkItem(parentView: parent, itemView: itemView)
            }
            itemView.isCollapsed = !itemView.isCollapsed
        }
    }
    
    private func shrinkItem(parentView: UIScrollView, itemView: AboutTableItemView) {
        //itemView.rotateArrow()
        let itemsToShift = itemViews[itemView.item.order+1..<itemViews.count]
        let itemYChange = itemView.getContentHeight()
        let itemHeight = itemView.getTitleHeight()
        
        let width = UIScreen.main.bounds.width
        let height: CGFloat = frame.height - itemYChange
        
        UIView.animate(withDuration: 0.15, animations: { itemView.arrowLabel.transform = CGAffineTransform(rotationAngle: -.pi/2) })
        
        UIView.animate(withDuration: 0.15,
                       animations: {
                        itemView.frame = CGRect(x: itemView.frame.origin.x, y: itemView.frame.origin.y, width: itemView.frame.width, height: itemHeight)
                        itemsToShift.forEach({ $0.frame.origin = $0.frame.origin.applying(CGAffineTransform(translationX: 0, y: -itemYChange)) })
                        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: width, height: height)
                        parentView.contentSize = CGSize(width: width, height: height) },
                       completion: { (finished: Bool) in
                        self.isAnimating = false })
    }
    
    private func expandItem(parentView: UIScrollView, itemView: AboutTableItemView) {
        //itemView.rotateArrow()
        let itemsToShift = itemViews[itemView.item.order+1..<itemViews.count]
        let itemYChange = itemView.getContentHeight()
        let itemHeight = itemView.getTitleHeight() + itemYChange
        
        let width = UIScreen.main.bounds.width
        let height: CGFloat = frame.height + itemYChange
        
        UIView.animate(withDuration: 0.15, animations: { itemView.arrowLabel.transform = CGAffineTransform(rotationAngle: 0) })
        
        UIView.animate(withDuration: 0.15,
                       animations: {
                        itemView.frame = CGRect(x: itemView.frame.origin.x, y: itemView.frame.origin.y, width: itemView.frame.width, height: itemHeight)
                        itemsToShift.forEach({ $0.frame.origin = $0.frame.origin.applying(CGAffineTransform(translationX: 0, y: itemYChange)) })
                        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: width, height: height)
                        parentView.contentSize = CGSize(width: width, height: height) },
                       completion: { (finished: Bool) in
                        self.isAnimating = false })
    }
    
    private func setColor() {
        backgroundColor = ColorPallete.transparent
    }
    
    private func placeChildViews() {
        var height: CGFloat = AboutTableItemView.padding_v
        for itemView in itemViews {
            itemView.frame.origin.y = height
            addSubview(itemView)
            height += itemView.frame.height + AboutTableItemView.padding_v
        }
    }
}
