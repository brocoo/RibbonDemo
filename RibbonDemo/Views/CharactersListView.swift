import Combine
import SwiftUI

struct CharactersListView: View {
    
    // MARK: Properties
    
    @ObservedObject var viewModel: CharactersListViewModel
    
    // MARK: Initializer
    
    init(provider: CharactersProviding) {
        self.viewModel = CharactersListViewModel(provider: provider)
    }
    
    // MARK: View lifecycle
    
    var body: some View {
        List(viewModel.characters) { character in
            Text("\(character.name)")
        }.onAppear {
            viewModel.loadCharacters()
        }
    }
}

// MARK: Preview provider

struct CharactersListView_Previews: PreviewProvider {
    
    static var previews: some View {
        let provider = MockProvider()
        CharactersListView(provider: provider)
    }
}

extension CharactersListView_Previews {
    
    private final class MockProvider: CharactersProviding {

        func fetchAllCharacters() { }
        
        var charactersPublisher: AnyPublisher<Result<[Character], Error>, Never> {
            let characters = (0..<10).map { index in
                Character(id: index, name: "NAME_\(index)", imageURL: nil)
            }
            return Just(.success(characters)).eraseToAnyPublisher()
        }
    }
}
