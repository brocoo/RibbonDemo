import SwiftUI

@main
struct RibbonDemoApp: App {
    
    // MARK: Properties
    
    private let client: NetworkClientProtocol
    private let charactersProvider: CharactersProviding
    
    // MARK: Initializer
    
    init() {
        let client = NetworkClient(session: URLSession.shared)
        self.client = client
        self.charactersProvider = CharactersProvider(client: client)
    }
    
    // MARK: View lifecycle
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CharactersListView(provider: charactersProvider)
            }
        }
    }
}
