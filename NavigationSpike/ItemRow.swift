import ComposableArchitecture
import SwiftUI

struct ItemRow: ReducerProtocol {
    enum Route {
        case one, two
    }
    struct State: Identifiable, Equatable {
        var id = UUID()
        var itemDetail: ItemDetail.State = .init()
        @BindableState var route: Route? = nil
    }
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case itemDetail(ItemDetail.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Scope(state: \.itemDetail, action: /Action.itemDetail) {
            ItemDetail()
        }
    }
}
struct RowItemView: View {
    var store: StoreOf<ItemRow>
    @ObservedObject var viewStore: ViewStoreOf<ItemRow>

    init(store: StoreOf<ItemRow>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    var body: some View {
            VStack {
                NavigationLink(
                    tag: ItemRow.Route.one,
                    selection: viewStore.binding(\.$route),
                    destination: {
                        ItemDetailView(store: store.scope(state: \.itemDetail, action: ItemRow.Action.itemDetail))
                    }) {
                        Text("Navigate from link 1")
                    }

                NavigationLink(
                    tag: ItemRow.Route.two,
                    selection: viewStore.binding(\.$route),
                    destination: {
                        ItemDetailView(store: store.scope(state: \.itemDetail, action: ItemRow.Action.itemDetail))
                    }) {
                        Text("Navigate from link 2")
                    }
            }
    }
}
