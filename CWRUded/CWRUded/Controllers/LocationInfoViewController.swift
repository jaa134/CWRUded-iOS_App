//
//  LocationInfoViewController.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/24/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import MapKit

class LocationInfoViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleIconLabel: UILabel!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    public var location: Location?
    private var locationView: LocationView?
    private var directionsButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupView() {
        setTitle()
        setScrollView()
        setLocationView()
        setDirectionsButton()
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateLocationViewContent), userInfo: nil, repeats: true)
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
        titleIconLabel.text = "\u{f129}"
        titleIconLabel.textColor = ColorPallete.white
        
        titleTextLabel.backgroundColor = ColorPallete.grey
        titleTextLabel.layer.cornerRadius = 5
        titleTextLabel.clipsToBounds = true
        titleTextLabel.textColor = ColorPallete.white
    }
    
    private func setScrollView() {
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        scrollView.backgroundColor = ColorPallete.clay
    }
    
    private func setLocationView() {
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        locationView = LocationView(location: location!)
        locationView!.transform = CGAffineTransform(translationX: 0, y: 10)
        scrollView.addSubview(locationView!)
    }
    
    @objc private func updateLocationViewContent() {
        for location in CrowdedData.singleton.locations {
            if (self.location!.id == location.id) {
                self.location = location
                break;
            }
        }
        self.locationView!.update(location: self.location!)
    }
    
    private func setDirectionsButton() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 10, y: locationView!.frame.height + 20, width: UIScreen.main.bounds.width - 20, height: 40)
        button.backgroundColor = ColorPallete.darkGrey
        button.setTitle("Directions", for: .normal)
        button.setTitleColor(ColorPallete.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(directionsButtonTapped), for: .touchUpInside)
        self.directionsButton = button
        scrollView.addSubview(directionsButton!)
    }
    
    @objc private func directionsButtonTapped(sender: UIButton!) {
        guard let location = location else { return }
        let addressDict = [CNPostalAddressStreetKey: location.name]
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
        
    }
    
    private func setScrollHeight() {
        let paddingSpace: CGFloat = 30
        scrollView.contentSize = CGSize(width: view.frame.width,
                                        height: paddingSpace + locationView!.frame.height + directionsButton!.frame.height)
    }
}
