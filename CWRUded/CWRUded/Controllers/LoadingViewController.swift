//
//  LoadingViewController.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/19/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setBackgroundColor()
        addRetryTapGesture()
        delayLoadAppData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = ColorPallete.navyBlue
    }
    
    //My brother and I spent a lot of time making the custom loading screen artwork
    //Yall gonna have to appreciate to it
    private func delayLoadAppData() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(loadAppData), userInfo: nil, repeats: false)
    }
    
    @objc private func loadAppData() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        CrowdedData.singleton.update(onNetworkError: onUpdateNetworkError, onDataError: onUpdateDataError, onSuccess: onUpdateSuccess)
    }
    
    private func showErrorHandlers() {
        let text = NSMutableAttributedString(string: "There was a problem communicating with the server. Would you like to ")
        let toUnderLineText = NSAttributedString(string: "try again?", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        text.append(toUnderLineText)
        errorLabel.attributedText = text
        errorLabel.textColor = ColorPallete.white
        errorLabel.backgroundColor = ColorPallete.transparent
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 5
        errorLabel.sizeToFit()
        errorLabel.isHidden = false
    }
    
    private func hideErrorHandlers() {
        errorLabel.isHidden = true
    }
    
    private func addRetryTapGesture() {
        errorLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(retryTapped))
        tap.numberOfTapsRequired = 1
        errorLabel.addGestureRecognizer(tap)
    }
    
    @objc private func retryTapped() {
        hideErrorHandlers()
        loadAppData()
    }
    
    func onUpdateNetworkError() {
        DispatchQueue.main.async {
            let message = "The server could not be reached at this time. Would you like to try again?"
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Network Error", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: { action in self.loadAppData() }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action in self.showErrorHandlers()}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func onUpdateDataError() {
        DispatchQueue.main.async {
            let message = "The server encountered an error. Would you like to try again?"
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Server Error", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: { action in self.loadAppData() }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action in self.showErrorHandlers()}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func onUpdateSuccess() {
        CrowdedData.singleton.order()
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "toHome", sender: self)
        }
    }
}

