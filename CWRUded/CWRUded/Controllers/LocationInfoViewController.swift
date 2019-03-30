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
    
    private var favoriteToggle: UISwitch!
    private var blacklistToggle: UISwitch!
    
    public var location: Location?
    private var locationView: LocationInfo?
    
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
        layoutComponents()
        setScrollHeight()
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateLocationViewContent), userInfo: nil, repeats: true)
    }
    
    private func setTitle() {
        setTitle(container: titleView,
                 iconLabel: titleIconLabel,
                 textLabel: titleTextLabel,
                 icon: Icons.info,
                 title: " Info")
    }
    
    private func setScrollView() {
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        scrollView.backgroundColor = ColorPallete.clay
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
    
    private func layoutComponents() {
        locationView = LocationInfo(location: location!)
        locationView!.transform = CGAffineTransform(translationX: 0, y: 10)
        scrollView.addSubview(locationView!)
        
        let containerWidth = UIScreen.main.bounds.width - 20
        let directionsButton = self.directionsButton(x: 10, y: 10, width: containerWidth - 20)
        let favoriteToggleRow = self.favoriteContainer(x: 10, y: directionsButton.frame.origin.y + directionsButton.frame.height + 10, width: containerWidth - 20)
        let blacklistToggleRow = self.blacklistContainer(x: 10, y: favoriteToggleRow.frame.origin.y + favoriteToggleRow.frame.height + 10, width: containerWidth - 20)
        let actionsContainer = UIView()
        actionsContainer.addSubview(directionsButton)
        actionsContainer.addSubview(favoriteToggleRow)
        actionsContainer.addSubview(blacklistToggleRow)
        
        actionsContainer.frame.origin.x = 10
        actionsContainer.frame.origin.y = locationView!.frame.origin.y + locationView!.frame.height + 10
        actionsContainer.frame.size.width = containerWidth
        actionsContainer.frame.size.height = directionsButton.frame.height + favoriteToggleRow.frame.height + blacklistToggleRow.frame.height + 40
        actionsContainer.backgroundColor = ColorPallete.white
        actionsContainer.layer.cornerRadius = 5
        actionsContainer.clipsToBounds = true
        scrollView.addSubview(actionsContainer)
    }
    
    private func directionsButton(x: CGFloat, y: CGFloat, width: CGFloat) -> ActionButton {
        return ActionButton(text: "Directions",
                            textFont: Fonts.app(size: 23, weight: .bold),
                            icon: Icons.compass,
                            iconFont: Fonts.fontAwesome(size: 18),
                            backgroundColor: ColorPallete.darkGrey,
                            foregroundColor: ColorPallete.white,
                            frame: CGRect(x: x,
                                          y: y,
                                          width: width,
                                          height: 40),
                            action: { self.directionsButtonTapped() })
    }
    
    private func directionsButtonTapped() {
        guard let location = location else { return }
        let addressDict = [CNPostalAddressStreetKey: location.name]
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    private func favoriteContainer(x: CGFloat, y: CGFloat, width: CGFloat) -> UIView {
        let favoriteToggleContainer = UIView(frame: CGRect(x: x,
                                                           y: y,
                                                           width: width,
                                                           height: 40))
        
        let iconLabel = UILabel()
        iconLabel.text = Icons.heart
        iconLabel.font = Fonts.fontAwesome(size: 18)
        iconLabel.textColor = ColorPallete.red
        iconLabel.backgroundColor = ColorPallete.transparent
        iconLabel.textAlignment = .center
        iconLabel.baselineAdjustment = .alignCenters
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let textLabel = UILabel()
        textLabel.text = "Favorite"
        textLabel.font = Fonts.app(size: 23, weight: .bold)
        textLabel.textColor = ColorPallete.black
        textLabel.backgroundColor = ColorPallete.transparent
        textLabel.textAlignment = .left
        textLabel.baselineAdjustment = .alignCenters
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let toggleSwitch = UISwitch()
        toggleSwitch.isOn = AppSettings.singleton.favoriteLocations().contains(where: { simpleLocation in simpleLocation.id == self.location!.id })
        toggleSwitch.addTarget(self, action: #selector(favoriteToggled), for: .valueChanged)
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        favoriteToggleContainer.addSubview(iconLabel)
        favoriteToggleContainer.addSubview(textLabel)
        favoriteToggleContainer.addSubview(toggleSwitch)
        
        iconLabel.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        iconLabel.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        favoriteToggleContainer.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .leading, relatedBy: .equal, toItem: favoriteToggleContainer, attribute: .leading, multiplier: 1, constant: 0))
        favoriteToggleContainer.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .centerY, relatedBy: .equal, toItem: favoriteToggleContainer, attribute: .centerY, multiplier: 1, constant: 0))
        
        textLabel.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25))
        favoriteToggleContainer.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .leading, relatedBy: .equal, toItem: iconLabel, attribute: .trailing, multiplier: 1, constant: 0))
        favoriteToggleContainer.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: favoriteToggleContainer, attribute: .centerY, multiplier: 1, constant: 0))
        
        favoriteToggleContainer.addConstraint(NSLayoutConstraint(item: toggleSwitch, attribute: .trailing, relatedBy: .equal, toItem: favoriteToggleContainer, attribute: .trailing, multiplier: 1, constant: -10))
        favoriteToggleContainer.addConstraint(NSLayoutConstraint(item: toggleSwitch, attribute: .leading, relatedBy: .equal, toItem: textLabel, attribute: .trailing, multiplier: 1, constant: 10))
        favoriteToggleContainer.addConstraint(NSLayoutConstraint(item: toggleSwitch, attribute: .centerY, relatedBy: .equal, toItem: favoriteToggleContainer, attribute: .centerY, multiplier: 1, constant: 0))
        
        favoriteToggle = toggleSwitch
        return favoriteToggleContainer
    }
    
    @objc private func favoriteToggled() {
        if (favoriteToggle.isOn) {
            AppSettings.singleton.addFavoriteLocation(location: location!)
            //does not trigger the other toggles event so we hanbdle it below
            blacklistToggle.setOn(false, animated: true)
            blacklistToggled()
        }
        else {
            AppSettings.singleton.removeFavoriteLocation(location: location!)
        }
    }
    
    private func blacklistContainer(x: CGFloat, y: CGFloat, width: CGFloat) -> UIView {
        let blacklistToggleContainer = UIView(frame: CGRect(x: x,
                                                            y: y,
                                                            width: width,
                                                            height: 40))
        
        let iconLabel = UILabel()
        iconLabel.text = Icons.ban
        iconLabel.font = Fonts.fontAwesome(size: 18)
        iconLabel.textColor = ColorPallete.red
        iconLabel.backgroundColor = ColorPallete.transparent
        iconLabel.textAlignment = .center
        iconLabel.baselineAdjustment = .alignCenters
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let textLabel = UILabel()
        textLabel.text = "Hide"
        textLabel.font = Fonts.app(size: 23, weight: .bold)
        textLabel.textColor = ColorPallete.black
        textLabel.backgroundColor = ColorPallete.transparent
        textLabel.textAlignment = .left
        textLabel.baselineAdjustment = .alignCenters
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let toggleSwitch = UISwitch()
        toggleSwitch.isOn = AppSettings.singleton.blacklistedLocations().contains(where: { simpleLocation in simpleLocation.id == self.location!.id })
        toggleSwitch.addTarget(self, action: #selector(blacklistToggled), for: .valueChanged)
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        blacklistToggleContainer.addSubview(iconLabel)
        blacklistToggleContainer.addSubview(textLabel)
        blacklistToggleContainer.addSubview(toggleSwitch)
        
        iconLabel.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        iconLabel.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
        blacklistToggleContainer.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .leading, relatedBy: .equal, toItem: blacklistToggleContainer, attribute: .leading, multiplier: 1, constant: 0))
        blacklistToggleContainer.addConstraint(NSLayoutConstraint(item: iconLabel, attribute: .centerY, relatedBy: .equal, toItem: blacklistToggleContainer, attribute: .centerY, multiplier: 1, constant: 0))
        
        textLabel.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25))
        blacklistToggleContainer.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .leading, relatedBy: .equal, toItem: iconLabel, attribute: .trailing, multiplier: 1, constant: 0))
        blacklistToggleContainer.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: blacklistToggleContainer, attribute: .centerY, multiplier: 1, constant: 0))
        
        blacklistToggleContainer.addConstraint(NSLayoutConstraint(item: toggleSwitch, attribute: .trailing, relatedBy: .equal, toItem: blacklistToggleContainer, attribute: .trailing, multiplier: 1, constant: -10))
        blacklistToggleContainer.addConstraint(NSLayoutConstraint(item: toggleSwitch, attribute: .leading, relatedBy: .equal, toItem: textLabel, attribute: .trailing, multiplier: 1, constant: 10))
        blacklistToggleContainer.addConstraint(NSLayoutConstraint(item: toggleSwitch, attribute: .centerY, relatedBy: .equal, toItem: blacklistToggleContainer, attribute: .centerY, multiplier: 1, constant: 0))
        
        blacklistToggle = toggleSwitch
        return blacklistToggleContainer
    }
    
    @objc private func blacklistToggled() {
        if (blacklistToggle.isOn) {
            AppSettings.singleton.addBlacklistedLocation(location: location!)
            //does not trigger the other toggles event so we hanbdle it below
            favoriteToggle.setOn(false, animated: true)
            favoriteToggled()
        }
        else {
            AppSettings.singleton.removeBlacklistedLocation(location: location!)
        }
    }
    
    private func setScrollHeight() {
        var contentRect = CGRect.zero
        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        let bottomPadding: CGFloat = 10
        contentRect.size.height += bottomPadding
        scrollView.contentSize = contentRect.size
    }
}
