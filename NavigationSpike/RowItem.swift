import ComposableArchitecture
import SwiftUI

struct RowItem: ReducerProtocol {
    enum Route {
        case one, two
    }
    struct State: Identifiable, Equatable {
        var id = UUID()
        var child: ItemDetail.State = .init()
        @BindableState var route: Route? = nil
    }
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case child(ItemDetail.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Scope(state: \.child, action: /Action.child) {
            ItemDetail()
        }
    }
}
struct RowItemView: View {
    var store: StoreOf<RowItem>
    @ObservedObject var viewStore: ViewStoreOf<RowItem>

    init(store: StoreOf<RowItem>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    var body: some View {
            VStack {
                Text("Route is: " + String(describing: viewStore.state.route))
                NavigationLink(
                    tag: RowItem.Route.one,
                    selection: viewStore.binding(\.$route),
                    destination: {
                        ItemDetailView(store: store.scope(state: \.child, action: RowItem.Action.child))
                    }) {
                        Text("Navigate from link 1")
                    }

                NavigationLink(
                    tag: RowItem.Route.two,
                    selection: viewStore.binding(\.$route),
                    destination: {
                        ItemDetailView(store: store.scope(state: \.child, action: RowItem.Action.child))
                    }) {
                        Text("Navigate from link 2")
                    }
            }
        
    }
}
