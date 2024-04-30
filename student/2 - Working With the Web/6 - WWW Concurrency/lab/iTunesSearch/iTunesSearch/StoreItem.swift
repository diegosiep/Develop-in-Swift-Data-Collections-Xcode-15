//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Diego Sierra on 25/04/24.
//

import Foundation

struct StoreItem: Codable {
    var trackName: String
    var artistName: String
    var kind: String
    var description: String
    var artworkUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case trackName
        case artistName
        case kind
        case description
        case artworkUrl = "artworkUrl100"
        
    }
    enum AdditionalKeys: CodingKey {
        case longDescription
    }
    
    init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.trackName = try values.decode(String.self, forKey: .trackName)
        self.artistName = try values.decode(String.self, forKey: .artistName)
        self.kind = try values.decode(String.self, forKey: .kind)
        self.artworkUrl = try values.decode(URL.self, forKey: .artworkUrl)
        
        if let description = try? values.decode(String.self, forKey: CodingKeys.description) {
            self.description = description
        } else {
            let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
            description = (try? additionalValues.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? ""
        }
    }
}

struct SearchResponse: Codable {
    let results: [StoreItem]
}

enum SearchResponseError: Error, LocalizedError {
    case couldNotCreateRequest
    case couldNotFetchImage
}

