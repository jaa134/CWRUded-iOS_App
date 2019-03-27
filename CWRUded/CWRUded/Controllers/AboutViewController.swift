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
        setTitle(container: titleView,
                 iconLabel: titleIconLabel,
                 textLabel: titleTextLabel,
                 icon: Icons.question,
                 title: " About")
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

