//
//  AppSettings.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/27/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation

struct SimpleLocation : Codable {
    let id: Int
    let name: String
}

class AppSettings {
    class Keys {
        static let refreshRate = "REFRESH_RATE"
        static let favoriteLocations = "FAVORITE_LOCATIONS"
        static let blacklistedLocations = "BLACKLISTED_LOCATIONS"
    }
    
    public static let singleton: AppSettings = AppSettings()
    
    private let defaults: UserDefaults
    
    private init() {
        self.defaults = UserDefaults.standard
    }
    
    private func defaultRefreshRate() -> TimeInterval {
        return 15.0
    }
    
    public func refreshRate() -> TimeInterval {
        return defaults.object(forKey: Keys.refreshRate) as? TimeInterval ?? defaultRefreshRate()
    }
    
    
    private func defaultFavoriteLocations() -> [SimpleLocation] {
        return []
    }
    
    public func favoriteLocations() -> [SimpleLocation] {
        guard let data = UserDefaults.standard.value(forKey: Keys.favoriteLocations) as? Data else { return [] }
        if let locations = try? PropertyListDecoder().decode([SimpleLocation].self, from: data) {
            return locations
        }
        else {
            //overwrite corrupted data
            updateFavoriteLocations(with: defaultFavoriteLocations())
            return defaultFavoriteLocations()
        }
    }
    
    private func updateFavoriteLocations(with locations: [SimpleLocation]) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(locations), forKey: AppSettings.Keys.favoriteLocations)
    }
    
    public func addFavoriteLocation(location: Location) {
        var favorites = favoriteLocations()
        favorites.append(SimpleLocation(id: location.id, name: location.name))
        updateFavoriteLocations(with: favorites)
    }
    
    public func removeFavoriteLocation(location: Location) {
        var favorites = favoriteLocations()
        favorites.removeAll(where: { simpleLocation in simpleLocation.id == location.id })
        updateFavoriteLocations(with: favorites)
    }
    
    private func defaultBlacklistedLocations() -> [SimpleLocation] {
        return []
    }
    
    public func blacklistedLocations() -> [SimpleLocation] {
        guard let data = UserDefaults.standard.value(forKey: Keys.blacklistedLocations) as? Data else { return [] }
        if let locations = try? PropertyListDecoder().decode([SimpleLocation].self, from: data) {
            return locations
        }
        else {
            //overwrite corrupted data
            updateBlacklistedLocations(with: defaultBlacklistedLocations())
            return defaultBlacklistedLocations()
        }
    }
    
    private func updateBlacklistedLocations(with locations: [SimpleLocation]) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(locations), forKey: AppSettings.Keys.blacklistedLocations)
    }
    
    public func addBlacklistedLocation(location: Location) {
        var blacklisted = blacklistedLocations()
        blacklisted.append(SimpleLocation(id: location.id, name: location.name))
        updateBlacklistedLocations(with: blacklisted)
    }
    
    public func removeBlacklistedLocation(location: Location) {
        var blacklisted = blacklistedLocations()
        blacklisted.removeAll(where: { simpleLocation in simpleLocation.id == location.id })
        updateBlacklistedLocations(with: blacklisted)
    }
}
