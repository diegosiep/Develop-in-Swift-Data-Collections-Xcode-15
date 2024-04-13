import UIKit

let url = URL(string: "https://itunes.apple.com/search")

var urlComponents = URLComponents(string: url!.absoluteString)

urlComponents?.queryItems = [
    "term": "Folke Grasbeck",
    "media": "music"
].map {
    URLQueryItem(name: $0.key, value: $0.value)
}

Task {
    let (data, response) = try await URLSession.shared.data(from: urlComponents!.url!)
    
    if let response = response as? HTTPURLResponse, response.statusCode == 200 {
        let data = String(data: data, encoding: .utf8)
        print(data!)
    }
}
    