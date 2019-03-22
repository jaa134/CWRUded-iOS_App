//
//  DataModel.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/20/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation

enum Type {
    case academic
    case dining
    case gym
}

struct Space {
    public let id: Int
    public let name: String
    public let capacity: Int
    
    fileprivate init(id: Int, name: String, capacity: Int) {
        self.id = id
        self.name = name
        self.capacity = capacity
    }
}

class Location {
    public let id: Int
    public let name: String
    public let type: Type
    public fileprivate(set) var spaces: [Space]
    
    fileprivate init(id: Int, name: String, type: Type, spaces: [Space]) {
        self.id = id
        self.name = name
        self.type = type
        self.spaces = spaces
    }
}

class CrowdedData {
    public static let singleton: CrowdedData = CrowdedData();
    
    private var filter: Type?
    private var locations: [Location]
    public private(set) var filteredLocations: [Location]
    
    private init() {
        filter = nil
        locations = [Location]()
        filteredLocations = [Location]()
    }
    
    private func generateNoise(avg: Int) -> Int {
       return Int.random(in: avg-7...avg+7)
    }
    
    func update() {
        locations.removeAll()
        
        var spaces = [Space]()
        
        spaces.append(Space(id: 1, name: "1st Floor", capacity: generateNoise(avg: 20)))
        spaces.append(Space(id: 2, name: "2nd Floor", capacity: generateNoise(avg: 75)))
        spaces.append(Space(id: 3, name: "3rd Floor", capacity: generateNoise(avg: 90)))
        let location1: Location = Location(id: 1, name: "Kelvin Smith Library", type: .academic, spaces: spaces)
        
        spaces.removeAll()
        spaces.append(Space(id: 4, name: "General", capacity: generateNoise(avg: 50)))
        let location2: Location = Location(id: 2, name: "Olin", type: .academic, spaces: spaces)
        
        spaces.removeAll()
        spaces.append(Space(id: 4, name: "General", capacity: generateNoise(avg: 33)))
        let location3: Location = Location(id: 3, name: "Veale Athletic Center", type: .gym, spaces: spaces)
        
        spaces.removeAll()
        spaces.append(Space(id: 4, name: "General", capacity: generateNoise(avg: 10)))
        let location4: Location = Location(id: 4, name: "Fribley Dining Hall", type: .dining, spaces: spaces)
        
        spaces.removeAll()
        spaces.append(Space(id: 4, name: "General", capacity: generateNoise(avg: 99)))
        let location5: Location = Location(id: 5, name: "Nord", type: .academic, spaces: spaces)
        
        spaces.removeAll()
        spaces.append(Space(id: 4, name: "General", capacity: generateNoise(avg: 66)))
        let location6: Location = Location(id: 6, name: "Strosacker", type: .academic, spaces: spaces)
        
        spaces.removeAll()
        spaces.append(Space(id: 4, name: "General", capacity: generateNoise(avg: 15)))
        let location7: Location = Location(id: 7, name: "Wyant Athletic Center", type: .gym, spaces: spaces)
        
        spaces.removeAll()
        spaces.append(Space(id: 4, name: "General", capacity: generateNoise(avg: 43)))
        let location8: Location = Location(id: 8, name: "Leutner Dining Hall", type: .dining, spaces: spaces)
        
        locations.append(location1)
        locations.append(location2)
        locations.append(location3)
        locations.append(location4)
        locations.append(location5)
        locations.append(location6)
        locations.append(location7)
        locations.append(location8)
        
        order()
    }
    
    func filter(type: Type?) {
        filter = type
        filteredLocations.removeAll()
        for location in locations {
            if (filter == nil || location.type == filter) {
                filteredLocations.append(location)
            }
        }
    }
    
    private func order() {
        for location in locations {
            location.spaces = location.spaces.sorted(by: { $0.name < $1.name })
        }
        locations = locations.sorted(by: { $0.name < $1.name })
    }
}
