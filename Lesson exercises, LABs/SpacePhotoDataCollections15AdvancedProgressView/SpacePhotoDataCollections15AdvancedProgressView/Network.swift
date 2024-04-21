//
//  Network.swift
//  SpacePhotoDataCollections15
//
//  Created by Diego Sierra on 20/04/24.
//

import UIKit

extension ViewController: URLSessionDelegate, URLSessionDataDelegate {
    enum PhotoInfoError: Error, LocalizedError {
        case itemNotFound
        case couldNotFetchImage
        case couldNotGenerateNetworkRequest
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        if let error = error {
            print("Failed with error: \(error)")
        } else {
            do {
                let jsonDecoder = JSONDecoder()
                let photoInfo = try jsonDecoder.decode(SpacePhoto.self, from: receivedData ?? Data())
                self.photoInfo = photoInfo
            } catch {
                self.updateUI(error)
            }
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        receivedData?.append(data)
    }
    
    func fetchPhotoInfo() async throws {
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")
        urlComponents?.queryItems = [
            "api_key": "sRkCcj5rC0pmdtRYXD9HCFQ0MeVWokgHMTBQfKuU",
            //            "date": "2024-04-14"
        ].map{ URLQueryItem(name: $0.key, value: $0.value) }
        guard let urlComponents = urlComponents, let url = urlComponents.url  else {
            throw PhotoInfoError.couldNotGenerateNetworkRequest
        }
        
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: request)
        task.resume()
        
    }
    
    func fetchPhotoImage(with url: URL) throws -> UIImage {
        var photoImage: UIImage?
        let downloadTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            photoImage = UIImage(data: data) ?? UIImage(systemName: "exclamationmark.icloud.fill")!
        }
        downloadTask.resume()
        
        guard let photoImage = photoImage else {
            throw PhotoInfoError.couldNotFetchImage
        }
        
        print(photoImage)
        return photoImage
    }
    
}
