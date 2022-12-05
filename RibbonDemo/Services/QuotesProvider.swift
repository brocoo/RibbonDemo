import Combine
import Foundation

/// Protocol responsible for providing quotes
protocol QuotesProviding {

    func fetchQuotes(for character: Character)

    var quotesPublisher: AnyPublisher<[Quote], Never> { get }
}

final class QuotesProvider {
    
    // MARK: Properties

    private let client: NetworkClientProtocol
    private let jsonDecoder = JSONDecoder()
    private let quotesSubject: PassthroughSubject<[Quote], Never> = PassthroughSubject()
    private var cancellables: Set<AnyCancellable> = Set()

    // MARK: Initialiser
    
    init(client: NetworkClientProtocol) {
        self.client = client
    }
}

// MARK: - QuotesProviding conformance

extension QuotesProvider: QuotesProviding {

    func fetchQuotes(for character: Character) {
        client
            .ressourcePublisher(for: .quotes(author: character.name))
            .decode(type: [Quote].self, decoder: jsonDecoder)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.quotesSubject.send([])
                }
            } receiveValue: { [weak self] quotes in
                self?.quotesSubject.send(quotes)
            }.store(in: &cancellables)
    }
    
    var quotesPublisher: AnyPublisher<[Quote], Never> {
        quotesSubject.eraseToAnyPublisher()
    }
}

