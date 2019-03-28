//
//  LocationsTable.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/27/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit

class LocationCell : UITableViewCell {
    public static let height: CGFloat = 50;
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var arrowLabel: UILabel!
    
    public var location: Location?
    
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
        self.countLabel.text = nil
        self.arrowLabel.text = nil
    }
    
    public func setupView(location: Location) {
        self.location = location
        setColor()
        setIcon()
        setTitle()
        setSpaceCount()
        setNavArrow()
    }
    
    private func setColor() {
        backgroundColor = ColorPallete.clay
    }
    
    private func setIcon() {
        guard let location = location else { return }
        iconLabel.backgroundColor = ColorPallete.transparent
        iconLabel.font = Fonts.fontAwesome(size: 20)
        iconLabel.text = Icons.from(type: location.type)
        iconLabel.textAlignment = .center
        iconLabel.textColor = ColorPallete.grey
        iconLabel.baselineAdjustment = .alignCenters
    }
    
    private func setTitle() {
        guard let location = location else { return }
        titleLabel.backgroundColor = ColorPallete.transparent
        titleLabel.font = Fonts.app(size: 20, weight: .regular)
        titleLabel.text = location.name
        titleLabel.textColor = ColorPallete.black
        titleLabel.baselineAdjustment = .alignCenters
    }
    
    private func setSpaceCount() {
        guard let location = location else { return }
        countLabel.backgroundColor = ColorPallete.transparent
        countLabel.font = Fonts.app(size: 15, weight: .regular)
        countLabel.text = location.displayCount
        countLabel.textColor = ColorPallete.black
        countLabel.baselineAdjustment = .alignCenters
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
