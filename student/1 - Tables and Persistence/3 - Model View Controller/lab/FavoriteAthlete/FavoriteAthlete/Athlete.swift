//
//  Athelte.swift
//  FavoriteAthlete
//
//  Created by Diego Sierra on 10/02/24.
//

import Foundation


struct Athlete: CustomStringConvertible {
    var name: String
    var age: Int
    var league: String
    var team: String
    
    var description: String {
        "\(name) is \(age) years old and plays for the \(team) in the \(league)."
    }
    
}
