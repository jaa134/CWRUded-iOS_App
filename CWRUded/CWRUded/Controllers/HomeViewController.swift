//
//  HomeViewController.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/19/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var academicButton: UIButton!
    @IBOutlet weak var diningButton: UIButton!
    @IBOutlet weak var gymButton: UIButton!
    @IBOutlet weak var showAllButton: UIButton!
    
    private var selectedFilterButton: UIButton?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFilterButtonIcons()
        roundFilterButtons()
        selectInitialButton(button: showAllButton)
        updateScrollViewContent()
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateScrollViewContent), userInfo: nil, repeats: true)
    }
    
    func addFilterButtonIcons() {
        academicButton.titleLabel?.font = UIFont(name: "FontAwesome5Free-Solid", size: 35)
        diningButton.titleLabel?.font = UIFont(name: "FontAwesome5Free-Solid", size: 35)
        gymButton.titleLabel?.font = UIFont(name: "FontAwesome5Free-Solid", size: 35)
        
        academicButton.setTitle("\u{f02d}", for: .normal)
        diningButton.setTitle("\u{f2e7}", for: .normal)
        gymButton.setTitle("\u{f44b}", for: .normal)
        
        academicButton.setTitleColor(ColorPallete.white, for: .normal)
        diningButton.setTitleColor(ColorPallete.white, for: .normal)
        gymButton.setTitleColor(ColorPallete.white, for: .normal)
    }
    
    func roundFilterButtons() {
        academicButton.layer.cornerRadius = 0.5 * academicButton.bounds.size.width
        academicButton.clipsToBounds = true
        diningButton.layer.cornerRadius = 0.5 * diningButton.bounds.size.width
        diningButton.clipsToBounds = true
        gymButton.layer.cornerRadius = 0.5 * gymButton.bounds.size.width
        gymButton.clipsToBounds = true
        showAllButton.layer.cornerRadius = 0.125 * showAllButton.bounds.height
        showAllButton.clipsToBounds = true
    }
    
    func selectInitialButton(button: UIButton) {
        button.backgroundColor = ColorPallete.darkGrey
        selectedFilterButton = button
    }
    
    func placeScrollViewContent() {
        let crowdedDataView = CrowdedDataView()
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        scrollView.addSubview(crowdedDataView)
    }
    
    func getTypeFromSelectedButton() -> Type? {
        switch (selectedFilterButton) {
        case academicButton: return .academic
        case diningButton: return .dining
        case gymButton: return .gym
        default: return nil
        }
    }
    
    @objc func updateScrollViewContent() {
        CrowdedData.singleton.update()
        let type = getTypeFromSelectedButton()
        CrowdedData.singleton.filter(type: type)
        placeScrollViewContent()
    }
    
    func pressButton(button: UIButton) {
        button.backgroundColor = ColorPallete.grey
    }
    
    func animateToColor(button: UIButton?, color: UIColor) {
        if let button = button {
            UIView.transition(with: button, duration: 0.25, options: .curveEaseInOut, animations: {
                button.backgroundColor = color
            })
        }
    }
    
    func selectButton(button: UIButton) {
        if (selectedFilterButton != button) {
            animateToColor(button: selectedFilterButton, color: ColorPallete.navyBlue)
            selectedFilterButton = button
            let type = getTypeFromSelectedButton()
            CrowdedData.singleton.filter(type: type)
            placeScrollViewContent()
        }
        animateToColor(button: button, color: ColorPallete.darkGrey)
    }
    
    @IBAction func academicButtonPressedDown(_ sender: Any) {
        pressButton(button: academicButton)
    }
    
    @IBAction func diningButtonPressedDown(_ sender: Any) {
        pressButton(button: diningButton)
    }
    
    @IBAction func gymButtonPressedDown(_ sender: Any) {
        pressButton(button: gymButton)
    }
    
    @IBAction func showAllButtonPressedDown(_ sender: Any) {
        pressButton(button: showAllButton)
    }
    
    @IBAction func academicButtonPressedUpInside(_ sender: Any) {
        selectButton(button: academicButton)
    }
    
    @IBAction func diningButtonPressedUpInside(_ sender: Any) {
        selectButton(button: diningButton)
    }
    
    @IBAction func gymButtonPressedUpInside(_ sender: Any) {
        selectButton(button: gymButton)
    }
    
    @IBAction func showAllButtonPressedUpInside(_ sender: Any) {
        selectButton(button: showAllButton)
    }
    
}

