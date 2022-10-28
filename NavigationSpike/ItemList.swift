import ComposableArchitecture
import SwiftUI

struct ItemList: ReducerProtocol {
    struct State: Equatable {
        var rows: IdentifiedArrayOf<ItemRow.State>
        @BindableState var selectedRow: ItemRow.State.ID?
    }
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case row(id: ItemRow.State.ID, action: ItemRow.Action)
    }
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
            .forEach(\.rows, action: /Action.row(id:action:)) {
                ItemRow()
            }
    }
}
struct ListItemView: View {
    var store: StoreOf<ItemList>
    @ObservedObject var viewStore: ViewStoreOf<ItemList>

    init(store: StoreOf<ItemList>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    var body: some View {
        List {
            /// This is ideally what we would like it to be, but it doesn't work
//            ForEachStore(store.scope(
//                state: \.rows,
//                action: ListItem.Action.row(id:action:))
//            ) { store in
//                WithViewStore(store) { itemViewStore in
//                    NavigationLink(
//                        tag: itemViewStore.id,
//                        selection: viewStore.binding(\.$selectedRow),
//                        destination: {
//                            RowItemView(store: store)
//                        },
//                        label: {
//                            Text(itemViewStore.id.description)
//                        }
//                    )
//                }
//            }


            /// Here we tried to narrow it down to check if the problem was the ForEachStore
            ForEach(viewStore.rows) { row in
                if let index = viewStore.rows.firstIndex(of: row) {
                    let scopedStored = store.scope(state: \.rows[index]) { childAction in
                        return .row(id: viewStore.rows[index].id, action: childAction)
                    }
                        NavigationLink(
                            tag: row.id,
                            selection: viewStore.binding(\.$selectedRow),
                            destination: {
                                /// The navigation works, but it doesn't maintain the state
//                                RowItemView(store: .init(initialState: .init(), reducer: RowItem()))


                                /// Whereas here, navigation doesn't work but state seems to be maintained
                                RowItemView(store: scopedStored)
                            },
                            label: {
                                Text(row.id.description)
                            }
                        )
                }
            }
        }
    }
}
