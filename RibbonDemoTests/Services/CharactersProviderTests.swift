import Combine
import XCTest
@testable import RibbonDemo

final class CharactersProviderTests: XCTestCase {

    // MARK: Properties
    
    private var mockNetworkClient: MockNetworkClient!
    private var cancellables: Set<AnyCancellable>!

    // MARK: XCTest lifecycle

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNetworkClient = MockNetworkClient()
        cancellables = Set()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockNetworkClient = nil
        cancellables = nil
    }
    
    // MARK: Tests
    
    func testItPublishesCharactersThenAnError() throws {
        
        // Given a data provider
        var resultsReceived: [Result<[Character], Error>] = []
        let provider = CharactersProvider(client: mockNetworkClient)
        provider
            .charactersPublisher
            .sink { resultsReceived.append($0) }
            .store(in: &cancellables)
        
        // And an expected list of characters
        let expectedCharacters = makeCharacters(count: 10)
        let jsonEncoder = JSONEncoder()
        let data = try XCTUnwrap(jsonEncoder.encode(expectedCharacters))
        mockNetworkClient.dataToReturn.append(.success(data))
        
        // When the data provider fetches the characters
        XCTAssertEqual(resultsReceived.count, 0)
        XCTAssertEqual(mockNetworkClient.endpointsCalled.count, 0)
        provider.fetchAllCharacters()
        
        // Then the characters endpoint is called
        XCTAssertEqual(mockNetworkClient.endpointsCalled.count, 1)
        XCTAssertEqual(mockNetworkClient.endpointsCalled[0], .characters)
        
        // And the result returned contains the expected characters posts
        XCTAssertEqual(resultsReceived.count, 1)
        guard case let .success(characters) = resultsReceived[0] else {
            XCTFail("Expected the result to be successful")
            return
        }
        XCTAssertEqual(characters, expectedCharacters)
        
        // When the network client returns an error
        let expectedError = NSError(domain: "", code: 1)
        mockNetworkClient.dataToReturn.append(.failure(expectedError))
        
        // And the data provider fetches the characters again
        provider.fetchAllCharacters()

        // Then the posts endpoint is called again
        XCTAssertEqual(mockNetworkClient.endpointsCalled.count, 2)
        XCTAssertEqual(mockNetworkClient.endpointsCalled[1], .characters)
        
        // And the result returned is the expected error
        XCTAssertEqual(resultsReceived.count, 2)
        guard case let .failure(error) = resultsReceived[1] else {
            XCTFail("Expected the result to be a failure")
            return
        }
        XCTAssertEqual(error as NSError, expectedError)
    }
}

// MARK: - Mock helpers

extension CharactersProviderTests {
    
    private func makeCharacters(count: Int) -> [Character] {
        (0..<count).map { index in
            Character(id: index, name: "CHARACTER_0", imageURL: URL(string: "https://image.com/\(index)"))
        }
    }
}
