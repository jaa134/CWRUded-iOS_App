//
//  HomeViewController.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/19/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleIconLabel: UILabel!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterIcon: UILabel!
    @IBOutlet weak var filterText: UILabel!
    @IBOutlet weak var filterTypeIcon: UILabel!
    @IBOutlet weak var filterTypeText: UILabel!
    
    //private var crowdedDataView: CrowdedDataView?
    private var locationsTable: LocationsTable?
    
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
        placeScrollViewContent()
        setInitialFilter()
        addFilterTapGesture()
    }
    
    private func setTitle() {
        setTitle(container: titleView,
                 iconLabel: titleIconLabel,
                 textLabel: titleTextLabel,
                 icon: Icons.home,
                 title: " Home")
    }
    
    private func setScrollView() {
        scrollView.backgroundColor = ColorPallete.clay
    }
    
    private func setInitialFilter() {
        filterView.backgroundColor = ColorPallete.darkGrey
        
        filterIcon.font = Fonts.fontAwesome(size: 20)
        filterIcon.textColor = ColorPallete.white
        filterIcon.text = Icons.filter
        
        filterText.font = Fonts.app(size: 30, weight: .heavy)
        filterText.textColor = ColorPallete.white
        filterText.text = "Filter"
        
        
        filterTypeIcon.font = Fonts.fontAwesome(size: 20)
        filterTypeIcon.textColor = ColorPallete.clay
        
        filterTypeText.font = Fonts.app(size: 20, weight: .heavy)
        filterTypeText.textColor = ColorPallete.clay
        
        setFilter(type: nil)
    }
    
    private func setFilter(type: Type?) {
        locationsTable?.filter(filter: type)
        updateScrollHeight()
        
        if let type = type {
            switch (type) {
            case .academic: filterTypeText.text = "Academic"
            case .dining: filterTypeText.text = "Dining"
            case .gym: filterTypeText.text = "Gym"
            }
            filterTypeIcon.text = Icons.from(type: type)
        }
        else {
            filterTypeText.text = ""
            filterTypeIcon.text = ""
        }
        filterTypeText.sizeToFit()
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
        locationsTable = LocationsTable(onCellTapped: { cell in self.performSegue(withIdentifier: "toInfo", sender: cell) })
        scrollView.addSubview(locationsTable!)
        updateScrollHeight()
    }
    
    private func updateScrollHeight() {
        let screensize: CGRect = UIScreen.main.bounds
        let scrollWidth: CGFloat = screensize.width
        let scrollHeight: CGFloat = locationsTable!.frame.height
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfo" {
            guard let infoViewController = segue.destination as? LocationInfoViewController else { return }
            guard let locationCell = sender as? LocationCell else { return }
            infoViewController.location = locationCell.location
        }
    }
}

