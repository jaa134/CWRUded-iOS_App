//
//  Icons.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/27/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation

class Icons {
    static let home = "\u{f015}"
    static let map = "\u{f279}"
    static let cog = "\u{f013}"
    static let question = "\u{f128}"
    static let info = "\u{f129}"
    static let filter = "\u{f0b0}"
    static let book = "\u{f02d}"
    static let utensils = "\u{f2e7}"
    static let dumbbell = "\u{f44b}"
    static let triangle = "\u{f0dd}"
    static let arrow = "\u{f105}"
    static let compass = "\u{f14e}"
    static let heart = "\u{f004}"
    
    public static func from(type: Type) -> String {
        switch type {
        case .academic: return Icons.book
        case .dining:   return Icons.utensils
        case .gym:      return Icons.dumbbell
        }
    }
}
