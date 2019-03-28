//
//  LocationPinView.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/24/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    public let location: Location
    
    var title: String? { return location.name }
    var subtitle: String? { return location.displayCount }
    var coordinate: CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude) }
    var markerTintColor: UIColor
    
    init(location: Location) {
        self.location = location
        self.markerTintColor = ColorPallete.navyBlue
        super.init()
    }
}

class LocationMarker: MKMarkerAnnotationView {
    var icon: UILabel?
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? LocationAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: 0, y: 20)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            markerTintColor = annotation.markerTintColor
            glyphText = ""
            displayPriority = .required
            
            if let icon = icon {
                icon.removeFromSuperview()
            }
            
            icon = UILabel()
            icon!.isUserInteractionEnabled = true
            icon!.font = Fonts.fontAwesome(size: 15)
            icon!.textColor = ColorPallete.white
            icon!.layer.zPosition = 9999
            
            switch annotation.location.type {
            case .academic: icon!.frame = CGRect(x: 7, y: 1.5, width: 20, height: 15)
            case .dining: icon!.frame = CGRect(x: 7, y: 1.5, width: 20, height: 15)
            case .gym: icon!.frame = CGRect(x: 4.5, y: 1.5, width: 20, height: 15)
            }
            icon!.text = Icons.from(type: annotation.location.type)
            
            addSubview(icon!)
        }
    }
}
