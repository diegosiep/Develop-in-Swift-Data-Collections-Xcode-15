//
//  File.swift
//  OrderApp
//
//  Created by Diego Sierra on 01/05/24.
//

import Foundation

class MenuController {
    static let shared = MenuController()
    
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
    
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: Self.orderUpdatedNotification, object: nil)
        }
    }
    
    enum MenuControllerError: Error, LocalizedError {
        case categoriesNotFound
        case menuItemsNotFound
        case orderRequestFailed
    }
    
    let baseURL = URL(string: "http://localhost:8080")!
    
    func fetchCategories() async throws -> [String] {
        if #available(iOS 16.0, *) {
            let categoriesURL = baseURL.appending(path: "categories")
            let (data, response) = try await URLSession.shared.data(from: categoriesURL)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw MenuControllerError.categoriesNotFound
            }
            
            let jsonDecoder = JSONDecoder()
            let fetchedCategories = try jsonDecoder.decode(CategoriesResponse.self, from: data)
            
            return fetchedCategories.categories
        } else {
            // Fallback on earlier versions
            let categoriesURL = baseURL.appendingPathComponent("categories")
            let (data, response) = try await URLSession.shared.data(from: categoriesURL)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw MenuControllerError.categoriesNotFound
            }
            
            let jsonDecoder = JSONDecoder()
            let fetchedCategories = try jsonDecoder.decode(CategoriesResponse.self, from: data)
            
            return fetchedCategories.categories
        }
    }
    
    func fetchMenuItems(forCategory categoryName: String) async throws -> [MenuItem] {
        if #available(iOS 16.0, *) {
            let baseMenuURL = baseURL.appending(path: "menu")
            var components = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)!
            components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
            let menuURL = components.url!
            let (data, response) = try await URLSession.shared.data(from: menuURL)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw MenuControllerError.menuItemsNotFound
            }
            
            let jsonDecoder = JSONDecoder()
            let fetchedMenuItems = try jsonDecoder.decode(MenuResponse.self, from: data)
            
            return fetchedMenuItems.items
        } else {
            // Fallback on earlier versions
            let baseMenuURL = baseURL.appendingPathComponent("menu")
            var components = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)!
            components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
            let menuURL = components.url!
            let (data, response) = try await URLSession.shared.data(from: menuURL)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw MenuControllerError.menuItemsNotFound
            }
            
            let jsonDecoder = JSONDecoder()
            let fetchedMenuItems = try jsonDecoder.decode(MenuResponse.self, from: data)
            
            return fetchedMenuItems.items
        }
    }
    
    typealias MinutesToPrepare = Int
    
    func submitOrder(forMenuIDs menuIDs: Int) async throws -> MinutesToPrepare {
        if #available(iOS 16.0, *) {
            let orderURL = baseURL.appending(path: "order")
            var request = URLRequest(url: orderURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let menuIDs = ["menu": [menuIDs]]
            let jsonEncoder = JSONEncoder()
            let encodedMenuIDs = try? jsonEncoder.encode(menuIDs)
            request.httpBody = encodedMenuIDs
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw MenuControllerError.orderRequestFailed
            }
            
            let jsonDecoder = JSONDecoder()
            let orderPrepTime = try jsonDecoder.decode(MinutesToPrepare.self, from: data)
            
            return orderPrepTime
            
        } else {
            // Fallback on earlier versions
            let orderURL = baseURL.appendingPathComponent("order")
            var request = URLRequest(url: orderURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let menuIDs = ["menu": [menuIDs]]
            let jsonEncoder = JSONEncoder()
            let encodedMenuIDs = try jsonEncoder.encode(menuIDs)
            request.httpBody = encodedMenuIDs
            
            let (data, response) = try await URLSession.shared.data(for: request)
        
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw MenuControllerError.orderRequestFailed
            }
            
            let jsonDecoder = JSONDecoder()
            let orderPrepTime = try jsonDecoder.decode(MinutesToPrepare.self, from: data)
            
            return orderPrepTime
        }
    }
}
