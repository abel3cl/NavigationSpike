import SwiftUI

@main
struct NavigationSpikeApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ListItemView(
                    store: .init(
                        initialState: .init(
                            rows: .init(
                                uniqueElements: [
                                    .init(),
                                    .init()]
                            )
                        ),
                        reducer: ListItem()
                    )
                )
            }
        }
    }
}
