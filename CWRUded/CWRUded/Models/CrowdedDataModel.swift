//
//  DataModel.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/20/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation

enum Type : String, Codable {
    case academic
    case dining
    case gym
}

struct Space : Decodable {
    public let id: Int
    public let name: String
    public let congestionRating: Int
    
    fileprivate init(id: Int, name: String, congestionRating: Int) {
        self.id = id
        self.name = name
        self.congestionRating = congestionRating
    }
}

struct Location : Decodable {
    public let id: Int
    public let name: String
    public let type: Type
    public fileprivate(set) var spaces: [Space]
    public let longitude: Double
    public let latitude: Double
    
    public var displayCount: String? { return String(spaces.count) + " " + (spaces.count != 1 ? "Locations" : "Location") }
    
    fileprivate init(id: Int, name: String, type: Type, spaces: [Space], longitude: Double, latitude: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.spaces = spaces
        self.longitude = longitude
        self.latitude = latitude
    }
}

class CrowdedData {
    public static let singleton: CrowdedData = CrowdedData();
    
    private var urlSessionConfig: URLSessionConfiguration
    private var filter: Type?
    public private(set) var locations: [Location]
    
    private init() {
        filter = nil
        locations = [Location]()
        urlSessionConfig = URLSessionConfiguration.default
        urlSessionConfig.timeoutIntervalForRequest = 20
        urlSessionConfig.timeoutIntervalForResource = 10
    }
    
    func update(onNetworkError: @escaping ()->(), onDataError: @escaping ()->(), onSuccess: @escaping ()->()) {
        let url = URL(string: "http://cwruded.herokuapp.com/api/locations")!
        
        let session = URLSession(configuration: urlSessionConfig)
        let task = session.dataTask(with: url) {(data, response, error) in
            guard error == nil else {
                print("HTTP request error...")
                onNetworkError()
                return
            }
            guard let data = data else {
                print("No data to decode...")
                onDataError()
                return
            }
            guard let locations = try? JSONDecoder().decode([Location].self, from: data) else {
                print("Error: Couldn't decode data into Locations set...")
                onDataError()
                return
            }
            self.locations = locations
            onSuccess()
        }
        
        task.resume()
    }
    
    func filteredLocations(filter: Type?) -> [Location] {
        var filteredLocations = [Location]()
        for location in locations {
            if (filter == nil || location.type == filter) {
                filteredLocations.append(location)
            }
        }
        return filteredLocations
    }
    
    func order() {
        for i in 0..<locations.count {
            locations[i].spaces = locations[i].spaces.sorted(by: { $0.name < $1.name })
        }
        locations = locations.sorted(by: { $0.name < $1.name })
    }
}
