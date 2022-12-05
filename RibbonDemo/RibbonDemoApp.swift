import SwiftUI

@main
struct RibbonDemoApp: App {
    
    // MARK: Properties
    
    private let client: NetworkClientProtocol
    private let charactersProvider: CharactersProviding
    private let likesProvider: LikesProviding
    private let quotesProvider: QuotesProviding
    
    // MARK: Initializer
    
    init() {
        let client = NetworkClient(session: URLSession.shared)
        self.client = client
        self.charactersProvider = CharactersProvider(client: client)
        self.likesProvider = LikesProvider(storage: .standard)
        self.quotesProvider = QuotesProvider(client: client)
    }
    
    // MARK: View lifecycle
    
    var body: some Scene {
        WindowGroup {
            if isRunningUnitTests() {
                EmptyView()
            } else {
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
    }

    // MARK: Helpers
    
    private func isRunningUnitTests() -> Bool {
        #if DEBUG
        let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        guard !isUnitTesting else {
            return true
        }
        #endif
        return false
    }
    
    private func makeCharacterListViewModel() -> CharactersListViewModel {
        CharactersListViewModel(charactersProvider: charactersProvider,
                                likesProvider: likesProvider)
    }
    
    private func makeCharacterDetailViewModel(for character: Character) -> CharacterDetailViewModel {
        CharacterDetailViewModel(character: character,
                                 likesProvider: likesProvider,
                                 quotesProvider: quotesProvider)
    }
}
