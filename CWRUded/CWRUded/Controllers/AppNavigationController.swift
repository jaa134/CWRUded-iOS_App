//
//  AppNavigationController.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/19/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import UIKit

class AppNavigationController: UITabBarController, UITabBarControllerDelegate {
    
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        changeTabFont()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        adjustTabHeight()
    }
    
    func changeTabFont() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)!], for: .focused)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)!], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)!], for: .disabled)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)!], for: .highlighted)
    }
    
    func adjustTabHeight() {
        let newTabBarHeight = defaultTabBarHeight + 5.0
        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight
        tabBar.frame = newFrame
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //do something when tab changes
    }
}
