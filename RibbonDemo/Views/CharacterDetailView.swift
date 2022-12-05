import Combine
import SwiftUI

struct CharacterDetailView: View {
    
    // MARK: Properties
    
    @ObservedObject var viewModel: CharacterDetailViewModel
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders, .sectionFooters]) {
            Section {
                AsyncImage(url: viewModel.character.imageURL)
            } footer: {
                characterHeaderView
            }
        }
    }
    
    private var characterHeaderView: some View {
        HStack {
            Text(viewModel.character.name)
            Spacer()
            Button {
                viewModel.toggleLike()
            } label: {
                Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
            }
        }
    }
}

// MARK: Preview provider

struct CharacterDetailView_Previews: PreviewProvider {

    static var previews: some View {
        let character = Character(id: 0,
                                  name: "John Appleseed",
                                  imageURL: nil)
        let viewModel = CharacterDetailViewModel(character: character,
                                                likesProvider: LikesProvider())
        return CharacterDetailView(viewModel: viewModel)
    }
}
