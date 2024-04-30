//
//  Network.swift
//  SpacePhotoDataCollections15
//
//  Created by Diego Sierra on 20/04/24.
//

import UIKit

extension ViewController: URLSessionDownloadDelegate, URLSessionTaskDelegate, URLSessionDelegate, URLSessionDataDelegate {
    enum PhotoInfoError: Error, LocalizedError {
        case couldNotFetchPhotoInfo
        case serverError
    }
    
    
    func fetchPhotoInfo() {
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")
        urlComponents?.queryItems = [
            "api_key": "sRkCcj5rC0pmdtRYXD9HCFQ0MeVWokgHMTBQfKuU",
//             for video: "date": "2024-04-14",
            "thumbs": "true"
        ].map{ URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let urlComponents = urlComponents else {
            return
        }
        
        let downloadPhotoInfoTask = self.session.downloadTask(with: urlComponents.url!)
        downloadPhotoInfoTask.resume()
        self.downloadPhotoInfoTask = downloadPhotoInfoTask
        
    }
    
    func fetchPhotoImage(with url: URL)  {
        let downloadPhotoInfoImageTask = self.session.downloadTask(with: url)
        downloadPhotoInfoImageTask.resume()
        self.downloadPhotoInfoImageTask = downloadPhotoInfoImageTask
    }
    
    func fetchPhotoInfoVideoInfo(with url: URL) {
        let downloadPhotoInfoImageTask = self.session.downloadTask(with: url)
        downloadPhotoInfoImageTask.resume()
        self.downloadPhotoInfoImageTask = downloadPhotoInfoImageTask
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "play.fill"), style: .plain, target: self, action: #selector(openAPODURL))
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        switch downloadTask {
        case downloadPhotoInfoTask:
            
            do {
                let jsonDecoder = JSONDecoder()
                let retrievedData = try Data(contentsOf: location)
                let decodedPhotoInfo = try jsonDecoder.decode(SpacePhoto.self, from: retrievedData)
                self.photoInfo = decodedPhotoInfo
                DispatchQueue.main.async {
                    self.updateUI(with: decodedPhotoInfo)
                }
            } catch {
                DispatchQueue.main.async {
                    self.updateUI(error)
                }
            }
        case downloadPhotoInfoImageTask:
            
            if let _ = photoInfo?.thumbnailUrl {
                do {
                    let retrievedImage = try UIImage(data: Data(contentsOf: location))
                    DispatchQueue.main.async {
                        self.imageView.image = retrievedImage
                        if self.progressView.progress == 1.0 {
                            self.progressView.isHidden = true
                            UIApplication.shared.open(self.photoInfo!.url)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.updateUI(error)
                    }
                }
            } else {
                do {
                    let retrievedImage = try UIImage(data: Data(contentsOf: location))
                    DispatchQueue.main.async {
                        self.imageView.image = retrievedImage
                        if self.progressView.progress == 1.0 {
                            self.progressView.isHidden = true
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.updateUI(error)
                    }
                }
            }
        default:
            break
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if downloadTask == self.downloadPhotoInfoImageTask {
            DispatchQueue.main.async {
                self.progressView.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        guard let response = task.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            DispatchQueue.main.async {
                self.updateUI(PhotoInfoError.serverError)
            }
            return
        }
        if let _ =  error {
            self.updateUI(PhotoInfoError.couldNotFetchPhotoInfo)
        }
    }
    
}
