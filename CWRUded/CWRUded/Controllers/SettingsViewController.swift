//
//  SettingsViewController.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/19/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleIconLabel: UILabel!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setTitle()
        setScrollView()
    }
    
    private func setTitle() {
        titleView.backgroundColor = ColorPallete.white
        titleView.layer.masksToBounds = false
        titleView.layer.shadowColor = UIColor.black.cgColor
        titleView.layer.shadowOpacity = 0.5
        titleView.layer.shadowOffset = CGSize(width: 0, height: 1)
        titleView.layer.shadowRadius = 1
        var rect = titleView.bounds
        rect.size.width = UIScreen.main.bounds.width
        titleView.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        titleView.layer.shouldRasterize = true
        titleView.layer.rasterizationScale = UIScreen.main.scale
        titleView.layer.zPosition = 1000
        
        titleIconLabel.backgroundColor = ColorPallete.navyBlue
        titleIconLabel.layer.cornerRadius = 0.5 * titleIconLabel.bounds.size.width
        titleIconLabel.clipsToBounds = true
        titleIconLabel.font = UIFont(name: "FontAwesome5Free-Solid", size: 35)
        titleIconLabel.text = "\u{f013}"
        titleIconLabel.textColor = ColorPallete.white
        
        titleTextLabel.backgroundColor = ColorPallete.grey
        titleTextLabel.layer.cornerRadius = 5
        titleTextLabel.clipsToBounds = true
        titleTextLabel.textColor = ColorPallete.white
    }
    
    private func setScrollView() {
        scrollView.backgroundColor = ColorPallete.clay
    }
}
