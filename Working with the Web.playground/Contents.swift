import UIKit

var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")
urlComponents?.queryItems = [
    "api_key": "DEMO_KEY",
    "date": ""
].map{ URLQueryItem(name: $0.key, value: $0.value) }

Task {
    let (data, response) = try await URLSession.shared.data(from: urlComponents!.url!)
    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
        let string = String(data: data, encoding: .utf8)
        print(string)
    } else {
        print("error")
    }
}


// 'Parse' means in programming, to convert information represented in one form into another form that's easier to work with. You take some data type and transform it into another data type.
