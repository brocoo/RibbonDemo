import Combine
import Foundation

final class CharactersListViewModel: ObservableObject {
 
    // MARK: Properties

    @Published var characters: [Character] = []
    @Published var error: Error?

    private let provider: CharactersProviding
    private var cancellables: Set<AnyCancellable> = Set()
    
    // MARK: Initializer
    
    init(provider: CharactersProviding) {
        self.provider = provider

        provider
            .charactersPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                switch result {
                case let .success(characters):
                    self?.characters = characters
                case let .failure(error):
                    self?.error = error
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: Helpers
    
    func loadCharacters() {
        provider.fetchAllCharacters()
    }
}
