//
//  Order.swift
//  OrderApp
//
//  Created by Diego Sierra on 01/05/24.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
