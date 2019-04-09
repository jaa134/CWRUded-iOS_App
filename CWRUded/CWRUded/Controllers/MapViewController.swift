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
    
    var mapView: MKMapView!
    var updateTimer: Timer!
    
    private var selectedFilter: Type?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupView() {
        setTitle()
        setFilterButton()
        setMapView()
    }
    
    private func setTitle() {
        setTitle(container: titleView,
                 iconLabel: titleIconLabel,
                 textLabel: titleTextLabel,
                 icon: Icons.map,
                 title: " Map")
    }
    
    private func setMapView() {
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        view.addSubview(mapView)
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 90))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        
        
        setInitialMapLocation()
        registerCustomPins()
        placeLocationAnnotations()
        updateTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(updateAnnotationViews), userInfo: nil, repeats: true)
    }
    
    private func unsetMapView() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeFromSuperview()
        mapView = nil
        
        updateTimer.invalidate()
        updateTimer = nil
    }
    
    private func setFilterButton() {
        filterButton.isUserInteractionEnabled = true
        filterButton.backgroundColor = ColorPallete.darkGrey
        filterButton.layer.cornerRadius = 0.5 * filterButton.bounds.size.width
        filterButton.clipsToBounds = true
        filterButton.font = Fonts.fontAwesome(size: 25)
        filterButton.text = Icons.filter
        filterButton.textColor = ColorPallete.white
        filterButton.layer.zPosition = 9999
        
        addFilterTapGesture()
    }
    
    private func setFilter(type: Type?) {
        selectedFilter = type
        placeLocationAnnotations()
        
        if let type = type {
            filterButton.text = Icons.from(type: type)
        }
        else {
            filterButton.text = Icons.filter
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
        mapView.register(LocationMarker.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    private func setInitialMapLocation() {
        let campusCoordinates = CLLocationCoordinate2D(latitude: 41.506750, longitude: -81.606210)
        centerMapOnLocation(location: campusCoordinates, radius: 1200)
        
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
    
    @objc private func updateAnnotationViews() {
        for annotation in mapView.annotations {
            if let view = mapView.view(for: annotation) as? LocationMarker {
                view.update()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toInfo") {
            guard let infoViewController = segue.destination as? LocationInfoViewController else { return }
            guard let markerView = sender as? LocationMarker else { return }
            guard let annotation = markerView.annotation as? LocationAnnotation else { return }
            infoViewController.location = annotation.location
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let view = view as? LocationMarker else { return }
        view.icon?.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let view = view as? LocationMarker else { return }
        view.icon?.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let view = view as? LocationMarker else { return }
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
