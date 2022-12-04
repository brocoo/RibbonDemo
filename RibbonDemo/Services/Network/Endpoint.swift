import Foundation

enum Endpoint {

    enum Method: String {
        case get
        case post
        case put
    }

    // MARK: Cases
    
    case characters
    
    // MARK: Properties

    var method: Method {
        switch self {
        case .characters:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .characters:
            return "/api/characters"
        }
    }
    
    var queryItems: [URLQueryItem] {
        []
    }
}
