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
    fileprivate let location: Location
    
    var title: String? { return location.name }
    var subtitle: String? { return String(location.spaces.count) + " " + (location.spaces.count != 1 ? "locations" : "location") }
    var coordinate: CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: 41.508303, longitude: -81.606210) }
    var markerTintColor: UIColor
    
    init(location: Location) {
        self.location = location
        self.markerTintColor = ColorPallete.navyBlue
        super.init()
    }
}

class LocationMarkerView: MKMarkerAnnotationView {
    var icon: UILabel?
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? LocationAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: 0, y: 0)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            markerTintColor = annotation.markerTintColor
            glyphText = ""
            
            if let icon = icon {
                icon.removeFromSuperview()
            }
            
            icon = UILabel()
            icon!.isUserInteractionEnabled = true
            icon!.font = UIFont(name: "FontAwesome5Free-Solid", size: 15)
            icon!.textColor = ColorPallete.white
            icon!.layer.zPosition = 9999
            
            if (annotation.location.type == .academic) {
                icon!.frame = CGRect(x: 7, y: 1.5, width: 20, height: 15)
                icon!.text = "\u{f02d}"
            }
            else if (annotation.location.type == .dining) {
                icon!.frame = CGRect(x: 7, y: 1.5, width: 20, height: 15)
                icon!.text = "\u{f2e7}"
            }
            else if (annotation.location.type == .gym) {
                icon!.frame = CGRect(x: 4.5, y: 1.5, width: 20, height: 15)
                icon!.text = "\u{f44b}"
            }
            
            addSubview(icon!)
        }
    }
}
