import Foundation

struct Character {

    let id: Int
    let name: String
    let imageURL: URL?
}

// MARK: - Decodable conformance

extension Character: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "char_id"
        case name
        case imageURL = "img"
    }
}

// MARK: - Hashable conformance

extension Character: Hashable { }
