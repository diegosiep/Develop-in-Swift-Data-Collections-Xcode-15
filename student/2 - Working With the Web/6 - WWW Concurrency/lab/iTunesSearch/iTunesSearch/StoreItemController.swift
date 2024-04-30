//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Diego Sierra on 25/04/24.
//

import Foundation
import UIKit

class StoreItemController {
    func fetchItems(matching query: [String: String]) async throws -> [StoreItem] {
        let url = URL(string: "https://itunes.apple.com/search")
        var urlComponents = URLComponents(string: url!.absoluteString)
        
        urlComponents?.queryItems = query.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        let (data, response) = try await URLSession.shared.data(from: (urlComponents!.url!))
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SearchResponseError.couldNotCreateRequest
        }
        
        let jsonDecoder = JSONDecoder()
        let searchResponse = try jsonDecoder.decode(SearchResponse.self, from: data)
        
        return searchResponse.results
        
    }
    
    func fetchItemImage(with url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SearchResponseError.couldNotCreateRequest
        }
        
       
        
        let storeItemImage = UIImage(data: data)
        
        guard let storeItemImage = storeItemImage else {
            throw SearchResponseError.couldNotFetchImage
        }
        
        return storeItemImage
    }
}
