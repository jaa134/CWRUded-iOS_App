//
//  SettingCell.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/29/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit

class SettingCell : UITableViewCell {
    public static let height: CGFloat = 44;
    
    public private(set) var setting: Setting!
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowLabel: UILabel!
    
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
        self.arrowLabel.text = nil
    }
    
    public func setupView(setting: Setting) {
        self.setting = setting
        setColor()
        setIcon()
        setTitle()
        setNavArrow()
    }
    
    private func setColor() {
        backgroundColor = ColorPallete.clay
    }
    
    private func setIcon() {
        iconLabel.backgroundColor = ColorPallete.transparent
        iconLabel.font = Fonts.fontAwesome(size: 20)
        iconLabel.text = setting.icon
        iconLabel.textAlignment = .center
        iconLabel.textColor = ColorPallete.grey
        iconLabel.baselineAdjustment = .alignCenters
    }
    
    private func setTitle() {
        titleLabel.backgroundColor = ColorPallete.transparent
        titleLabel.font = Fonts.app(size: 20, weight: .regular)
        titleLabel.text = setting.name
        titleLabel.textColor = ColorPallete.black
        titleLabel.baselineAdjustment = .alignCenters
    }
    
    private func setNavArrow() {
        arrowLabel.backgroundColor = ColorPallete.transparent
        arrowLabel.font = Fonts.fontAwesome(size: 12)
        arrowLabel.text = Icons.arrow
        arrowLabel.textAlignment = .center
        arrowLabel.textColor = ColorPallete.darkGrey
        arrowLabel.baselineAdjustment = .alignCenters
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

struct Setting {
    let icon: String
    let name: String
    let onClick: () -> ()
}

