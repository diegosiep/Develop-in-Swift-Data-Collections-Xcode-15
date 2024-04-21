import UIKit

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
        case artworkUrl = "artworkUrl30"
        
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
}
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

Task {
    do {
        let searchItems = try await fetchItems(matching: [
            "term": "Diego Sierra Sibelius",
            "media": "music",
            "limit": "10"
        ])
        
        searchItems.forEach { searchItem in
            print("""
                  Artist: \(searchItem.artistName)
                  Song: \(searchItem.trackName)
                  Artwork URL: \(searchItem.artworkUrl)
""")
        }
    } catch {
        print("error")
    }
}

extension Data {
    func prettyPrintedJSONString() {
        guard
            let jsonObject = try?
                JSONSerialization.jsonObject(with: self, options: []),
            let jsonData = try?
                JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
            let prettyJSONString = String(data: jsonData, encoding: .utf8) else {
            print("Failed to read JSON object")
            return
        }
        print(prettyJSONString)
        
    }
    
}
