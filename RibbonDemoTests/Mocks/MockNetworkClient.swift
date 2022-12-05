import Combine
import Foundation
@testable import RibbonDemo

final class MockNetworkClient {
    
    // MARK: Properties
    
    private(set) var endpointsCalled: [Endpoint] = []
    var dataToReturn: [Result<Data, Error>] = []
}

// MARK: NetworkClientProtocol conformance

extension MockNetworkClient: NetworkClientProtocol {

    func dataPublisher(for endpoint: Endpoint) -> AnyPublisher<Data, Error> {
        endpointsCalled.append(endpoint)
        switch dataToReturn.popLast()! {
        case let .success(data):
            return Just(data)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case let.failure(error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
