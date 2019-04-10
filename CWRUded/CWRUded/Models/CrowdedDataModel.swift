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

class Rating : Codable {
    public let value: Int
    public let createdOn: Date
    
    fileprivate init(value: Int, createdOn: Date) {
        self.value = value
        self.createdOn = createdOn
    }
}

class Space : Codable {
    public let id: Int
    public let name: String
    public fileprivate(set) var history: [Rating]
    
    fileprivate init(id: Int, name: String, history: [Rating]) {
        self.id = id
        self.name = name
        self.history = history
    }
}

struct SimpleLocation : Codable {
    let id: Int
    let name: String
}

class Location : Codable {
    public let id: Int
    public let type: Type
    public let name: String
    public let latitude: Double
    public let longitude: Double
    public fileprivate(set) var spaces: [Space]
    
    public var displayCount: String? { return String(spaces.count) + " " + (spaces.count != 1 ? "Locations" : "Location") }
    
    fileprivate init(id: Int, type: Type, name: String, latitude: Double, longitude: Double, spaces: [Space]) {
        self.id = id
        self.type = type
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.spaces = spaces
    }
    
    public func averagedOrderedHistory() -> [Double] {
        var uniqueTimestamps = [Date]()
        for space in spaces {
            for rating in space.history {
                if (!uniqueTimestamps.contains(rating.createdOn)) {
                    uniqueTimestamps.append(rating.createdOn)
                }
            }
        }
        
        let numHistoryPoints = uniqueTimestamps.count
        
        var sums = [Int]()
        var samples = [Int]()
        for _ in 0..<numHistoryPoints {
            sums.append(0)
            samples.append(0)
        }
        
        for space in spaces {
            for rating in space.history {
                if let index = uniqueTimestamps.firstIndex(of: rating.createdOn) {
                    sums[index] += rating.value
                    samples[index] += 1
                }
            }
        }
        
        var averages = [Double]()
        for i in 0..<numHistoryPoints {
            averages.append(Double(sums[i]) / Double(samples[i]))
        }
        return averages
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
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            guard let locationsFromServer = try? decoder.decode([Location].self, from: data) else {
                print("Error: Couldn't decode data into Locations set...")
                onDataError()
                return
            }
            
            //do not simply replace. We use classes so we can pass by reference around the app
            for locationFromServer in locationsFromServer {
                if let existingLocation = self.locations.first(where: { $0.id == locationFromServer.id }) {
                    for spaceFromServer in locationFromServer.spaces {
                        if let existingSpace = existingLocation.spaces.first(where: { $0.id == spaceFromServer.id }) {
                            existingSpace.history = spaceFromServer.history
                        }
                        else {
                            existingLocation.spaces.append(spaceFromServer)
                        }
                    }
                }
                else {
                    self.locations.append(locationFromServer)
                }
            }
            
            onSuccess()
        }
        
        task.resume()
    }
    
    func filteredLocations(filter: Type?) -> [Location] {
        var filteredLocations = [Location]()
        let blacklistedLocations = AppSettings.singleton.blacklistedLocations()
        let visibleLocations = locations.filter({ location in !blacklistedLocations.contains(where: { blocked in blocked.id == location.id }) })
        for location in visibleLocations {
            if (filter == nil || location.type == filter) {
                filteredLocations.append(location)
            }
        }
        return filteredLocations
    }
    
    func favoriteLocations() -> [Location] {
        let simpleLocations = AppSettings.singleton.favoriteLocations()
        var favoriteLocations = [Location]()
        for simpleLocation in simpleLocations {
            for location in locations {
                if (location.id == simpleLocation.id) {
                    favoriteLocations.append(location)
                    break;
                }
            }
        }
        return favoriteLocations
    }
    
    func nonFavoriteFilteredLocations(filter: Type?) -> [Location] {
        let simpleLocations = AppSettings.singleton.favoriteLocations()
        var nonFavoriteLocations = [Location]()
        for location in self.filteredLocations(filter: filter) {
            if (simpleLocations.allSatisfy({ location.id != $0.id })) {
                nonFavoriteLocations.append(location)
            }
        }
        return nonFavoriteLocations
    }
    
    func order() {
        for i in 0..<locations.count {
            locations[i].spaces = locations[i].spaces.sorted(by: { $0.name < $1.name })
        }
        locations = locations.sorted(by: { $0.name < $1.name })
    }
}
