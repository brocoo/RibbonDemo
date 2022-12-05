import Combine
import XCTest
@testable import RibbonDemo

final class NetworkClientTests: XCTestCase {

    // MARK: Properties
    
    private var session: MockURLSession!

    // MARK: XCTest lifecycle

    override func setUpWithError() throws {
        try super.setUpWithError()
        session = MockURLSession()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        session = nil
    }

    // MARK: Tests

    func testItSendsCharacterRequests() {
        let networkClient = NetworkClient(session: session)
    
        XCTAssertEqual(session.requestsSent.count, 0)
        let _ = networkClient.dataPublisher(for: .characters)
        XCTAssertEqual(session.requestsSent.count, 1)
        
        let request = session.requestsSent[0]
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.absoluteString, "https://breakingbadapi.com/api/characters")
    }
    
    func testItSendsQuotesRequests() {
        let networkClient = NetworkClient(session: session)
    
        XCTAssertEqual(session.requestsSent.count, 0)
        let _ = networkClient.dataPublisher(for: .quotes(author: "John Appleseed"))
        XCTAssertEqual(session.requestsSent.count, 1)
        
        let request = session.requestsSent[0]
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.absoluteString, "https://breakingbadapi.com/api/quote?author=John+Appleseed")
    }
}
