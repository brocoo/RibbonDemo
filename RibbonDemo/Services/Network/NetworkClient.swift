import Combine
import Foundation

/// Protocol responsible for performing API calls over the network
protocol NetworkClientProtocol {

    /// Calls the provided endpoint over the network returning a publisher of data
    func dataPublisher(for endpoint: Endpoint) -> AnyPublisher<Data, Error>
}

/// Concrete network client
final class NetworkClient {
    
    // MARK: Constants
    
    enum Constants {
        static let scheme = "https"
        static let host = "breakingbadapi.com"
    }

    // MARK: Properties
    
    private let session: URLSessionProtocol
    
    // MARK: Initializer

    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    // MARK: Helpers
    
    private func makeURLRequest(from endpoint: Endpoint) -> URLRequest {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        guard let url = components.url else {
            fatalError("Missing URL from components: \(components) built from endpoint: \(endpoint)")
        }
        var request = URLRequest(url: url,
                                 cachePolicy: session.configuration.requestCachePolicy,
                                 timeoutInterval: session.configuration.timeoutIntervalForRequest)
        request.httpMethod = endpoint.method.rawValue
        return request
    }
}

// MARK: - NetworkClientProtocol conformance

extension NetworkClient: NetworkClientProtocol {

    func dataPublisher(for endpoint: Endpoint) -> AnyPublisher<Data, Error> {
        let request = makeURLRequest(from: endpoint)
        return session
            .dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    throw NetworkError.requestFailure
                }
                return data
            }.eraseToAnyPublisher()
    }
}

// MARK: - Custom error

enum NetworkError: CustomNSError {

    case requestFailure

    static var errorDomain: String {
        "com.brocoo.RibbonDemo.networkClient"
    }
}
