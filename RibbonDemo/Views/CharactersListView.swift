import Combine
import SwiftUI

struct CharactersListView: View {
    
    // MARK: Properties
    
    @ObservedObject var viewModel: CharactersListViewModel

    // MARK: View lifecycle
    
    var body: some View {
        List(viewModel.characters) { likeableCharacter in
            NavigationLink(value: likeableCharacter.character) {
                characterView(likeableCharacter)
            }
        }.onAppear {
            viewModel.loadCharacters()
        }.navigationTitle("Characters")
    }
    
    private func characterView(_ likeableCharacter: CharactersListViewModel.LikeableCharacter) -> some View {
        let character = likeableCharacter.character
        let isLiked = likeableCharacter.isLiked
        return HStack(alignment: .top) {
            Text(character.name)
            Spacer()
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .renderingMode(.template)
                .foregroundColor(.blue)
                .onTapGesture {
                    viewModel.toggleLike(for: character)
                }
        }
    }
}

// MARK: Preview provider

struct CharactersListView_Previews: PreviewProvider {
    
    static var previews: some View {
        let charactersProvider = MockCharactersProvider()
        let likesProvider = LikesProvider()
        let viewModel = CharactersListViewModel(charactersProvider: charactersProvider,
                                                likesProvider: likesProvider)
        CharactersListView(viewModel: viewModel)
    }
}

extension CharactersListView_Previews {
    
    private final class MockCharactersProvider: CharactersProviding {

        func fetchAllCharacters() { }
        
        var charactersPublisher: AnyPublisher<Result<[Character], Error>, Never> {
            let characters = (0..<10).map { index in
                Character(id: index, name: "NAME_\(index)", imageURL: nil)
            }
            return Just(.success(characters)).eraseToAnyPublisher()
        }
    }
}
