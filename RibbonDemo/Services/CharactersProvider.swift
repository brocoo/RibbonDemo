import Foundation
import Combine

/// Protocol responsible for providing characters
protocol CharactersProviding {

    func fetchAllCharacters()

    var charactersPublisher: AnyPublisher<Result<[Character], Error>, Never> { get }
}

final class CharactersProvider {
    
    // MARK: Properties

    private let client: NetworkClientProtocol
    private let jsonDecoder = JSONDecoder()
    private let charactersSubject: PassthroughSubject<Result<[Character], Error>, Never> = PassthroughSubject()
    private var cancellables: Set<AnyCancellable> = Set()

    // MARK: Initialiser
    
    init(client: NetworkClientProtocol) {
        self.client = client
    }
}

// MARK: - CharactersProviding conformance

extension CharactersProvider: CharactersProviding {

    func fetchAllCharacters() {
        client
            .ressourcePublisher(for: .characters)
            .decode(type: [Character].self, decoder: jsonDecoder)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.charactersSubject.send(.failure(error))
                }
            } receiveValue: { [weak self] characters in
                self?.charactersSubject.send(.success(characters))
            }.store(in: &cancellables)
    }
    
    var charactersPublisher: AnyPublisher<Result<[Character], Error>, Never> {
        charactersSubject.eraseToAnyPublisher()
    }
}
