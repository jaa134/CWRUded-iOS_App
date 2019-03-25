//
//  HomeViewController.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/19/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var titleIconLabel: UILabel!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterIcon: UILabel!
    @IBOutlet weak var filterText: UILabel!
    @IBOutlet weak var filterTypeIcon: UILabel!
    @IBOutlet weak var filterTypeText: UILabel!
    
    private var crowdedDataView: CrowdedDataView?
    private var selectedFilter: Type?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupView() {
        setTitle()
        setScrollView()
        setInitialFilter()
        addFilterTapGesture()
        placeScrollViewContent()
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateScrollViewContent), userInfo: nil, repeats: true)
    }
    
    private func setTitle() {
        titleIconLabel.backgroundColor = ColorPallete.navyBlue
        titleIconLabel.layer.cornerRadius = 0.5 * titleIconLabel.bounds.size.width
        titleIconLabel.clipsToBounds = true
        titleIconLabel.font = UIFont(name: "FontAwesome5Free-Solid", size: 35)
        titleIconLabel.text = "\u{f015}"
        titleIconLabel.textColor = ColorPallete.white
        
        titleTextLabel.backgroundColor = ColorPallete.grey
        titleTextLabel.layer.cornerRadius = 5
        titleTextLabel.clipsToBounds = true
        titleTextLabel.textColor = ColorPallete.white
    }
    
    private func setScrollView() {
        scrollView.backgroundColor = ColorPallete.clay
    }
    
    private func setInitialFilter() {
        filterView.backgroundColor = ColorPallete.darkGrey
        
        filterIcon.font = UIFont(name: "FontAwesome5Free-Solid", size: 20)
        filterIcon.textColor = ColorPallete.white
        filterIcon.text = "\u{f0b0}"
        
        filterText.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        filterText.textColor = ColorPallete.white
        filterText.text = "Filter"
        
        
        filterTypeIcon.font = UIFont(name: "FontAwesome5Free-Solid", size: 16)
        filterTypeIcon.textColor = ColorPallete.clay
        
        filterTypeText.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        filterTypeText.textColor = ColorPallete.clay
        
        setFilter(type: nil)
    }
    
    private func setFilter(type: Type?) {
        selectedFilter = type
        placeScrollViewContent()
        
        if let type = type {
            if (type == .academic) {
                filterTypeIcon.text = "\u{f02d}"
                filterTypeText.text = "Academic"
            }
            else if (type == .dining) {
                filterTypeIcon.text = "\u{f2e7}"
                filterTypeText.text = "Dining"
            }
            else if (type == .gym) {
                filterTypeIcon.text = "\u{f44b}"
                filterTypeText.text = "Gym"
            }
        }
        else {
            filterTypeText.text = ""
            filterTypeIcon.text = ""
        }
    }
    
    private func addFilterTapGesture() {
        var tap: UITapGestureRecognizer
        tap = UITapGestureRecognizer(target: self, action: #selector(filterTapped))
        tap.numberOfTapsRequired = 1
        filterView.addGestureRecognizer(tap)
    }
    
    @objc private func filterTapped() {
        let filterActionSheet = UIAlertController(title: "Filter", message: "Select an option to filter locations.", preferredStyle: UIAlertController.Style.actionSheet)
        
        let allAction = UIAlertAction(title: "All", style: UIAlertAction.Style.default) { (action) in self.setFilter(type: nil) }
        let academicAction = UIAlertAction(title: "Academic", style: UIAlertAction.Style.default) { (action) in self.setFilter(type: .academic) }
        let diningAction = UIAlertAction(title: "Dining", style: UIAlertAction.Style.default) { (action) in self.setFilter(type: .dining) }
        let gymAction = UIAlertAction(title: "Gym", style: UIAlertAction.Style.default) { (action) in self.setFilter(type: .gym) }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        
        filterActionSheet.addAction(allAction)
        filterActionSheet.addAction(academicAction)
        filterActionSheet.addAction(diningAction)
        filterActionSheet.addAction(gymAction)
        filterActionSheet.addAction(cancelAction)
        
        self.present(filterActionSheet, animated: true, completion: nil)
    }
    
    private func placeScrollViewContent() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        crowdedDataView = CrowdedDataView(filter: selectedFilter)
        scrollView.addSubview(crowdedDataView!)
    }
    
    @objc private func updateScrollViewContent() {
        self.crowdedDataView!.update()
    }
    
    private func pressButton(button: UIButton) {
        button.backgroundColor = ColorPallete.grey
    }
    
    private func animateToColor(button: UIButton?, color: UIColor) {
        if let button = button {
            UIView.transition(with: button, duration: 0.25, options: .curveEaseInOut, animations: {
                button.backgroundColor = color
            })
        }
    }
    
}

