//
//  Registration.swift
//  Hotel Codable
//
//  Created by Diego Sierra on 06/03/24.
//

import Foundation


struct Registration {
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var wifi: Bool
    var roomType: RoomType
    
}
