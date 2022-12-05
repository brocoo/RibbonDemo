import Foundation
@testable import RibbonDemo

final class MockURLSession {
    
    // MARK: Properties
    
    private(set) var requestsSent: [URLRequest] = []
}

// MARK: - URLSessionProtocol conformance

extension MockURLSession: URLSessionProtocol {

    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        requestsSent.append(request)
        return URLSession.DataTaskPublisher(request: request, session: URLSession.shared)
    }
    
    var configuration: URLSessionConfiguration {
        URLSessionConfiguration.default
    }
}
