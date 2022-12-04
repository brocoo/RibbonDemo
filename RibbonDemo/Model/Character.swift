import Foundation

struct Character {

    let identifier: String
    let name: String
    let imageURL: URL?
}

// MARK: - Decodable conformance

extension Character: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case identifier = "char_id"
        case name
        case imageURL = "img"
    }
}
