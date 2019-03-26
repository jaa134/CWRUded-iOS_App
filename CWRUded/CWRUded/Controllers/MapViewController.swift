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
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleIconLabel: UILabel!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var filterButton: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
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
        setFilterButton()
        mapView.delegate = self
        registerCustomPins()
        setInitialMapLocation()
        placeLocationAnnotations()
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
        filterLocationAnnotations(filter: type)
        
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
        for location in CrowdedData.singleton.locations {
            let annotation = LocationAnnotation(location: location)
            mapView.addAnnotation(annotation)
        }
    }
    
    private func filterLocationAnnotations(filter: Type?) {
        for annotation in mapView.annotations {
            guard let annotation = annotation as? LocationAnnotation else { continue }
            guard let annotationView = mapView.view(for: annotation) else { continue }
            annotationView.isHidden = filter != nil && annotation.location.type != filter
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfo" {
            guard let infoViewController = segue.destination as? LocationInfoViewController else { return }
            guard let markerView = sender as? LocationMarkerView else { return }
            guard let annotation = markerView.annotation as? LocationAnnotation else { return }
            infoViewController.location = annotation.location
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let view = view as? LocationMarkerView else { return }
        view.icon?.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let view = view as? LocationMarkerView else { return }
        view.icon?.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let view = view as? LocationMarkerView else { return }
        performSegue(withIdentifier: "toInfo", sender: view)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let annotations = self.mapView.annotations
        for annotation in annotations {
            //if map becomes too cluttered with annotations, then uncomment out this line
            self.mapView.view(for: annotation)?.isHidden = false //self.mapView.region.span.latitudeDelta > 0.010
        }
    }
}
