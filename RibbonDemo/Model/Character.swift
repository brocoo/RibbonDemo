import Foundation

struct Character: Identifiable {

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
