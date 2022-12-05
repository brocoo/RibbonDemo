import Combine
import Foundation

final class CharacterDetailViewModel: ObservableObject {
    
    // MARK: Properties
    
    @Published var character: Character
    @Published var isLiked: Bool
    
    private var likesProvider: LikesProviding
    private var cancellables: Set<AnyCancellable> = Set()
    
    // MARK: Initializer
    
    init(character: Character, likesProvider: LikesProviding) {
        self.character = character
        self.isLiked = likesProvider[character.id]
        self.likesProvider = likesProvider
    }
    
    func toggleLike() {
        let id = character.id
        likesProvider[id].toggle()
        isLiked = likesProvider[id]
    }
}
