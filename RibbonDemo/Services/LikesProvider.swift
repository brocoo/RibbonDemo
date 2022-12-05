import Foundation

/// Protocol responsible for storing and providing liked characters
protocol LikesProviding {

    subscript(characterId: Int) -> Bool { get set }
}

final class LikesProvider: LikesProviding {
    
    // MARK: Constants
    
    enum Constants {
        static let storageKey = "likedCharactersIds"
    }
    
    // MARK: Properties
    
    private let storage: UserDefaults
    private var ids: Set<Int>
    
    // MARK: Initializer

    init(storage: UserDefaults = .standard) {
        self.storage = storage
        let idsArray = storage.array(forKey: Constants.storageKey) as? Array<Int>
        self.ids = Set(idsArray ?? [])
    }
    
    subscript(characterId: Int) -> Bool {
        get {
            ids.contains(characterId)
        }
        set {
            if !ids.contains(characterId) && newValue {
                ids.insert(characterId)
                storage.set(Array(ids), forKey: Constants.storageKey)
                storage.synchronize()
            } else if ids.contains(characterId) && !newValue {
                ids.remove(characterId)
                storage.set(Array(ids), forKey: Constants.storageKey)
                storage.synchronize()
            }
        }
    }
}
