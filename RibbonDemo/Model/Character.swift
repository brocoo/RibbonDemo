import Foundation

struct Character {

    let id: Int
    let name: String
    let imageURL: URL?
}

// MARK: - Codable conformance

extension Character: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "char_id"
        case name
        case imageURL = "img"
    }
}

// MARK: - Hashable conformance

extension Character: Hashable { }

// MARK: - Equatable conformance

extension Character: Equatable { }
