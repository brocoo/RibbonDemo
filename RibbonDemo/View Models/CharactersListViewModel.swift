import Combine
import Foundation

final class CharactersListViewModel: ObservableObject {
    
    // MARK: Model
    
    struct LikeableCharacter: Identifiable {

        let character: Character
        let isLiked: Bool
        
        var id: Int { character.id }
    }
    
    // MARK: Properties

    @Published private(set) var characters: [LikeableCharacter] = []
    @Published private(set) var error: Error?

    private let charactersProvider: CharactersProviding
    private var likesProvider: LikesProviding
    private var cancellables: Set<AnyCancellable> = Set()
    
    // MARK: Initializer
    
    init(charactersProvider: CharactersProviding, likesProvider: LikesProviding) {
        self.charactersProvider = charactersProvider
        self.likesProvider = likesProvider

        charactersProvider
            .charactersPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                switch result {
                case let .success(characters):
                    self?.characters = characters.map { character in
                        let isLiked = self?.likesProvider[character.id] ?? false
                        return LikeableCharacter(character: character, isLiked: isLiked)
                    }
                case let .failure(error):
                    self?.error = error
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: Business logic

    func loadCharacters() {
        charactersProvider.fetchAllCharacters()
    }
    
    func toggleLike(for character: Character) {
        let id = character.id
        let isLiked = !likesProvider[id]
        likesProvider[id] = isLiked
        let index = characters.firstIndex { $0.character.id == id }
        if let index {
            characters[index] = LikeableCharacter(character: character, isLiked: isLiked)
        }
    }
}
