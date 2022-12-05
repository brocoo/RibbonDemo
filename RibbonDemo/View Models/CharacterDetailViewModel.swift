import Combine
import Foundation

final class CharacterDetailViewModel: ObservableObject {
    
    // MARK: Properties
    
    @Published private(set) var character: Character
    @Published private(set) var isLiked: Bool
    @Published private(set) var quotes: [Quote] = []
    
    private var likesProvider: LikesProviding
    private var quotesProvider: QuotesProviding
    private var cancellables: Set<AnyCancellable> = Set()
    
    // MARK: Initializer
    
    init(character: Character, likesProvider: LikesProviding, quotesProvider: QuotesProviding) {
        self.character = character
        self.isLiked = likesProvider[character.id]
        self.likesProvider = likesProvider
        self.quotesProvider = quotesProvider
        
        quotesProvider
            .quotesPublisher
            .receive(on: RunLoop.main)
            .assign(to: &$quotes)
    }
    
    func loadQuotes() {
        quotesProvider
            .fetchQuotes(for: character)
    }
    
    func toggleLike() {
        let id = character.id
        likesProvider[id].toggle()
        isLiked = likesProvider[id]
    }
}
