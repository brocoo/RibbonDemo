import Foundation

protocol URLSessionProtocol {
 
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
    var configuration: URLSessionConfiguration { get }
}

extension URLSession: URLSessionProtocol { }
