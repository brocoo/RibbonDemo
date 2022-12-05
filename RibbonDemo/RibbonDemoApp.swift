import SwiftUI

@main
struct RibbonDemoApp: App {
    
    // MARK: Properties
    
    @State private var character: Character?
    
    private let client: NetworkClientProtocol
    private let charactersProvider: CharactersProviding
    private let likesProvider: LikesProviding
    
    // MARK: Initializer
    
    init() {
        let client = NetworkClient(session: URLSession.shared)
        self.client = client
        self.charactersProvider = CharactersProvider(client: client)
        self.likesProvider = LikesProvider(storage: .standard)
    }
    
    // MARK: View lifecycle
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CharactersListView(viewModel: makeCharacterListViewModel())
                .navigationDestination(for: Character.self) { character in
                    if let character = character {
                        CharacterDetailView(viewModel: makeCharacterDetailViewModel(for: character))
                    }
                }
            }
        }
    }

    // MARK: Helpers
    
    private func makeCharacterListViewModel() -> CharactersListViewModel {
        CharactersListViewModel(charactersProvider: charactersProvider,
                                likesProvider: likesProvider)
    }
    
    private func makeCharacterDetailViewModel(for character: Character) -> CharacterDetailViewModel {
        CharacterDetailViewModel(character: character,
                                 likesProvider: likesProvider)
    }
}
