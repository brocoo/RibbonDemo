import Foundation

struct Quote: Identifiable {

    let id: Int
    let value: String
}

// MARK: - Decodable conformance

extension Quote: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "quote_id"
        case value = "quote"
    }
}

// MARK: - Hashable conformance

extension Quote: Hashable { }
