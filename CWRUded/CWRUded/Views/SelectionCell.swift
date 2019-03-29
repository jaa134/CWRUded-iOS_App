//
//  SelectionCell.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/29/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit

class SelectionCell : UITableViewCell {
    public static let height: CGFloat = 44;
    
    public private(set) var item: Item!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.iconLabel.text = nil
        self.titleLabel.text = nil
    }
    
    public func setupView(item: Item) {
        self.item = item
        setColor()
        setTitle()
        setIcon()
        isSelected = item.isSelected
    }
    
    private func setColor() {
        backgroundColor = ColorPallete.clay
    }
    
    private func setTitle() {
        titleLabel.backgroundColor = ColorPallete.transparent
        titleLabel.font = Fonts.app(size: 20, weight: .regular)
        titleLabel.text = item.name
        titleLabel.textColor = ColorPallete.black
        titleLabel.baselineAdjustment = .alignCenters
    }
    
    private func setIcon() {
        iconLabel.backgroundColor = ColorPallete.transparent
        iconLabel.font = Fonts.fontAwesome(size: 20)
        iconLabel.text = item.icon
        iconLabel.textAlignment = .center
        iconLabel.textColor = item.iconColor
        iconLabel.baselineAdjustment = .alignCenters
        iconLabel.isHidden = !item.isSelected
    }
    
    public func toggle() {
        iconLabel.isHidden = item.isSelected
        item.isSelected = !item.isSelected
        if (item.isSelected) {
            item.onSelect()
        }
        else {
            item.onDeselect()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //self.contentView.backgroundColor = selected ? .red : .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        //self.contentView.backgroundColor = highlighted ? .blue : .clear
    }
}

struct Item {
    let name: String
    let icon: String
    let iconColor: UIColor
    public fileprivate(set) var isSelected: Bool
    let onSelect: () -> ()
    let onDeselect: () -> ()
}
