//
//  AboutViewController.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/19/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
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
        placeScrollViewContent()
    }
    
    private func setTitle() {
        titleIconLabel.backgroundColor = ColorPallete.navyBlue
        titleIconLabel.layer.cornerRadius = 0.5 * titleIconLabel.bounds.size.width
        titleIconLabel.clipsToBounds = true
        titleIconLabel.font = UIFont(name: "FontAwesome5Free-Solid", size: 35)
        titleIconLabel.text = "\u{f128}"
        titleIconLabel.textColor = ColorPallete.white
        
        titleTextLabel.backgroundColor = ColorPallete.grey
        titleTextLabel.layer.cornerRadius = 5
        titleTextLabel.clipsToBounds = true
        titleTextLabel.textColor = ColorPallete.white
    }
    
    private func setScrollView() {
        scrollView.backgroundColor = ColorPallete.clay
    }
    
    func placeScrollViewContent() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        let aboutTableDataView = AboutTableDataView()
        scrollView.addSubview(aboutTableDataView)
    }
}

