//
//  SpacePhoto.swift
//  SpacePhoto
//
//  Created by Diego Sierra on 14/04/24.
//

import Foundation

struct SpacePhoto: Codable {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    var mediaType: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
        case mediaType = "media_type"
    }
}

enum MediaType: String {
    case video = "video"
    case image = "image"
}

enum PhotoInfoError: Error, LocalizedError {
    case itemNotFound
}

