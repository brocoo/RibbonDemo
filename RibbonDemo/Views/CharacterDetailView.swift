import Combine
import SwiftUI

struct CharacterDetailView: View {
    
    // MARK: Properties
    
    @ObservedObject var viewModel: CharacterDetailViewModel
    
    // MARK: View lifecycle
    
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
                }
                Section {
                    ForEach(viewModel.quotes) { quote in
                        Text(quote.value).italic()
                        Divider()
                    }
                } header: {
                    characterHeaderView
                }
            }.padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadQuotes()
        }
    }
    
    // MARK: Custom views

    private var characterHeaderView: some View {
        HStack {
            Text(viewModel.character.name)
            Spacer()
            Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                .renderingMode(.template)
                .foregroundColor(Color(UIColor.link))
                .onTapGesture {
                    viewModel.toggleLike()
                }
        }
        .frame(height: 44)
        .font(.title)
        .background { Color(UIColor.systemBackground) }
    }
}

// MARK: Preview provider

struct CharacterDetailView_Previews: PreviewProvider {

    static var previews: some View {
        let character = Character(id: 0,
                                  name: "John Appleseed",
                                  imageURL: nil)
        let viewModel = CharacterDetailViewModel(character: character,
                                                likesProvider: LikesProvider(),
                                                 quotesProvider: MockQuotesProvider())
        return CharacterDetailView(viewModel: viewModel)
    }
}

extension CharacterDetailView_Previews {
    
    private final class MockQuotesProvider: QuotesProviding {

        func fetchQuotes(for character: Character) { }
        
        var quotesPublisher: AnyPublisher<[Quote], Never> {
            let quotes = (0..<20).map { index in
                let value = """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Leo integer malesuada nunc vel risus. Sit amet nisl purus in mollis nunc.
                """
                return Quote(id: index, value: "\(index): \(value)")
            }
            return Just(quotes).eraseToAnyPublisher()
        }
    }
}
