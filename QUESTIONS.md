# RibbonDemo

## Questions 

### What (if any) further additions would you like to make to your submission if you had more time?

- Cover the rest of the codebase with unit tests. I've only had the time to add test for the network client and one data provider. Ideally I would like to add tests for `LikesProvider`, `QuotesProvider` and the other view models.  
- UI Tests. I didn't have the time to add the UI tests, adding UI test coverage for the basic scenarios would have been great.
- Error handling. Although I started adding support for propagating network errors back to the UI layer, I didn't have the time to implement a good error handling mechanism, (i.e showing a meaningful error message, handling retries)
- Refresh mechanism. That could have a been a very quick win, adding a simple pull-to-refresh mechanism on both `CharactersListView` and `CharacterDetailView` views to reload data.
- Loading handling on both screens. whenever loading characters / character images & quote, displaying a loading spinner would be a great improvement. 
- Introduce some coordinator object that handles routing and navigating from one screen to another, and would be responsible for instanciating the view models required for each view. One benefit of this would be to decouple and move that logic away from the `RibbonDemoApp` scene.
- Better UI on the `CharacterDetailView`. A noticeable improvement on that screen can involve having the character image pinned in the background (probably using a ZStack), allowing the character name and quotes views to scroll over it. If the user puls the list down that image could also grow to take on the available height.   
- Some caching/persistence mechanism.   

### Is there anything you would change about your current implementation?

- In insight, having a provider for each model (i.e `CharactersProvider`, `QuotesProvider`) might not have been the best solution here. If I were to change that, I would probably kept a single `DataProvider` which could be a concrete implementation of both the model provinding protocols, that would slightly simplify the architecture. 
- Taking it one step further, maybe these model providers were an extra unecessary layer between the network client and the view models.
- There a small visual glitch visible when the user likes or unlikes a character from its detail screen and navigates back to the list. The heart icon isn't updated instantly in the list to reflect this change of state. This is due to the fact that the view model kicks off a character reload API call first and the change happens only once that list of characters is fetched again. One way to improve this is to either introduce the ability for the character detail view to directly mutate the list of `LikeableCharacter` used in the view before (which should trigger an layout update) or to manually and directly update the list of `LikeableCharacter` for changes in the Set of liked characters id once the user lands back on the previous screen.   
