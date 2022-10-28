import ComposableArchitecture
import SwiftUI

struct ListItem: ReducerProtocol {
    struct State: Equatable {
        var rows: IdentifiedArrayOf<RowItem.State>
        @BindableState var selectedRow: RowItem.State.ID?
    }
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case row(id: RowItem.State.ID, action: RowItem.Action)
    }
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
            .forEach(\.rows, action: /Action.row(id:action:)) {
                RowItem()
            }
    }
}
struct ListItemView: View {
    var store: StoreOf<ListItem>
    @ObservedObject var viewStore: ViewStoreOf<ListItem>

    init(store: StoreOf<ListItem>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    var body: some View {
        List {
            ForEachStore(store.scope(
                state: \.rows,
                action: ListItem.Action.row(id:action:))
            ) { store in
                WithViewStore(store) { itemViewStore in
                    NavigationLink(
                        tag: itemViewStore.id,
                        selection: viewStore.binding(\.$selectedRow),
                        destination: {
                            RowItemView(store: store)
                        },
                        label: {
                            Text(itemViewStore.id.description)
                        }
                    )
                }
            }
        }
    }
}

public extension Binding {
    func `is`<Item: Equatable>(equalTo item: Item)-> Binding<Item?> where Value == Bool {
        Binding<Item?>(
            get: { wrappedValue ? item : nil },
            set: {
                guard let newItem = $0 else {
                    wrappedValue = false
                    return
                }
                wrappedValue = (newItem == item)
            }
        )
    }
}
