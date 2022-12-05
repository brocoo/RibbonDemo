import Foundation

enum Endpoint {

    enum Method: String {
        case get
        case post
        case put
    }

    // MARK: Cases
    
    case characters
    case quotes(author: String)
    
    // MARK: Properties

    var method: Method {
        switch self {
        case .characters, .quotes:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .characters:
            return "/api/characters"
        case .quotes:
            return "/api/quote"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .characters:
            return nil
        case let .quotes(author):
            let escapedAuthor = author.replacingOccurrences(of: " ", with: "+")
            let query = URLQueryItem(name: "author", value: escapedAuthor)
            return [query]
        }
    }
}
