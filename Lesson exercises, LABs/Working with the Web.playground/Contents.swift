import UIKit

struct PhotoInfo: Codable {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
    }
}

enum PhotoInfoError: Error, LocalizedError {
    case itemNotFound
}

func fetchPhotoInfo() async throws -> PhotoInfo {
    var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")
    urlComponents?.queryItems = [
        "api_key": "DEMO_KEY",
    ].map{ URLQueryItem(name: $0.key, value: $0.value) }
    
    let (data, response) = try await URLSession.shared.data(from: urlComponents!.url!)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw PhotoInfoError.itemNotFound }
    
    let jsonDecoder = JSONDecoder()
    let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
    return photoInfo
}

Task {
    do {
        let photoInfo = try await fetchPhotoInfo()
        print("Succesfully fethced PhotoInfo: \(photoInfo)")
    } catch {
        print("Fetch PhotoInfo failed with error: \(error)")
    }
}

// 'Parse' means in programming, to convert information represented in one form into another form that's easier to work with. You take some data type and transform it into another data type.
