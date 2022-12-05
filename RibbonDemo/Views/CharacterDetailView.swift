import Combine
import SwiftUI

struct CharacterDetailView: View {
    
    // MARK: Properties
    
    @ObservedObject var viewModel: CharacterDetailViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                Section {
                    AsyncImage(url: viewModel.character.imageURL) { phase in
                        switch phase {
                        case let .success(image):
                            image.resizable().scaledToFit()
                        default:
                            EmptyView()
                        }
                    }
                }.background(Color.purple)
                Section {
                    
                } header: {
                    characterHeaderView
                }
            }.padding()
        }.navigationBarTitleDisplayMode(.inline)
    }
    
    private var characterHeaderView: some View {
        HStack {
            Text(viewModel.character.name)
            Spacer()
            Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                .renderingMode(.template)
                .foregroundColor(.blue)
                .onTapGesture {
                    viewModel.toggleLike()
                }
        }
        .font(.title)
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
