//
//  PhotoInfoController.swift
//  SpacePhoto
//
//  Created by Diego Sierra on 14/04/24.
//

import UIKit

class PhotoInfoController {
    enum PhotoInfoError: Error, LocalizedError {
        case itemNotFound
        case couldNotFetchImage
    }
    
    func fetchPhotoInfo() async throws -> PhotoInfo {
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")
        urlComponents?.queryItems = [
            "api_key": "sRkCcj5rC0pmdtRYXD9HCFQ0MeVWokgHMTBQfKuU",
//            "date": "2024-04-14"
        ].map{ URLQueryItem(name: $0.key, value: $0.value) }
    
        print(urlComponents!.url!)
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents!.url!)
       
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PhotoInfoError.itemNotFound
        }
       
        let jsonDecoder = JSONDecoder()
        let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
        return photoInfo
    }
    
    func fetchPhotoImage(with photoInfo: PhotoInfo) async throws -> UIImage {
        var urlComponents = URLComponents(url: photoInfo.url, resolvingAgainstBaseURL: true)
        urlComponents?.scheme = "https"
        print(urlComponents!.url!)
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents!.url!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PhotoInfoError.couldNotFetchImage
        }
      
        guard let photoInfoImage = UIImage(data: data) else {
            throw PhotoInfoError.couldNotFetchImage
        }
        
        return photoInfoImage
    }
    
}
