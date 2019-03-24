//
//  MapViewController.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/24/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var titleIconLabel: UILabel!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var filterButton: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    private var selectedFilter: Type?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setTitle()
        setFilterButton()
        registerCustomPins()
        setInitialMapLocation()
        placeLocationAnnotations()
    }
    
    private func setTitle() {
        titleIconLabel.backgroundColor = ColorPallete.navyBlue
        titleIconLabel.layer.cornerRadius = 0.5 * titleIconLabel.bounds.size.width
        titleIconLabel.clipsToBounds = true
        titleIconLabel.font = UIFont(name: "FontAwesome5Free-Solid", size: 35)
        titleIconLabel.text = "\u{f279}"
        titleIconLabel.textColor = ColorPallete.white
        
        titleTextLabel.backgroundColor = ColorPallete.grey
        titleTextLabel.layer.cornerRadius = 5
        titleTextLabel.clipsToBounds = true
        titleTextLabel.textColor = ColorPallete.white
    }
    
    private func setFilterButton() {
        filterButton.isUserInteractionEnabled = true
        filterButton.backgroundColor = ColorPallete.darkGrey
        filterButton.layer.cornerRadius = 0.5 * filterButton.bounds.size.width
        filterButton.clipsToBounds = true
        filterButton.font = UIFont(name: "FontAwesome5Free-Solid", size: 25)
        filterButton.text = "\u{f0b0}"
        filterButton.textColor = ColorPallete.white
        
        addFilterTapGesture()
    }
    
    private func setFilter(type: Type?) {
        selectedFilter = type
        placeLocationAnnotations()
        
        if let type = type {
            if (type == .academic) {
                filterButton.text = "\u{f02d}"
            }
            else if (type == .dining) {
                filterButton.text = "\u{f2e7}"
            }
            else if (type == .gym) {
                filterButton.text = "\u{f44b}"
            }
        }
        else {
            filterButton.text = "\u{f0b0}"
        }
    }
    
    private func addFilterTapGesture() {
        var tap: UITapGestureRecognizer
        tap = UITapGestureRecognizer(target: self, action: #selector(filterTapped))
        tap.numberOfTapsRequired = 1
        filterButton.addGestureRecognizer(tap)
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
    
    private func registerCustomPins() {
        mapView.register(LocationMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    private func setInitialMapLocation() {
        let campusCoordinates = CLLocationCoordinate2D(latitude: 41.508303, longitude: -81.606210)
        centerMapOnLocation(location: campusCoordinates, radius: 1000)
        
    }
    
    private func centerMapOnLocation(location: CLLocationCoordinate2D, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func placeLocationAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        for location in CrowdedData.singleton.filteredLocations(filter: selectedFilter) {
            let annotation = LocationAnnotation(location: location)
            mapView.addAnnotation(annotation)
        }
    }
}

