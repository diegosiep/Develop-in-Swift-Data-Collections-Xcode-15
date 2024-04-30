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
    var thumbnailUrl: URL?
    var copyright: String?
    var mediaType: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url = "hdurl"
        case copyright
        case mediaType = "media_type"
        case thumbnailUrl = "thumbnail_url"
    }
}

enum MediaType: String {
    case video = "video"
    case image = "image"
}


