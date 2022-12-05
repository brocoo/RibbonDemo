import SwiftUI

@main
struct RibbonDemoApp: App {
    
    // MARK: Properties
    
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
            NavigationView {
                CharactersListView(viewModel: CharactersListViewModel(charactersProvider: charactersProvider,
                                                                      likesProvider: likesProvider))
            }
        }
    }
}
