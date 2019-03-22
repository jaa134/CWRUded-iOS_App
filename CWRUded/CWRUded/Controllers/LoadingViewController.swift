//
//  LoadingViewController.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/19/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setBackgroundColor()
        setLoadFinishedTransition()
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = ColorPallete.navyBlue
    }
    
    private func setLoadFinishedTransition() {
        CrowdedData.singleton.update(onSuccess: {
            CrowdedData.singleton.filter(type: nil)
            CrowdedData.singleton.order()            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toHome", sender: self)
            }
        })
    }
}

