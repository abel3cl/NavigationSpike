import ComposableArchitecture
import SwiftUI

struct ItemDetail: ReducerProtocol {
    struct State: Equatable {
        var count: Int = 0
    }
    enum Action: Equatable {
        case increment
        case decrement
    }
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {

            case .increment:
                state.count += 1
                return .none
            case .decrement:
                state.count -= 1
                return .none
            }
        }
    }
}
struct ItemDetailView: View {
    var store: StoreOf<ItemDetail>

    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Button {
                    viewStore.send(.decrement)
                } label: {
                    Text("-")
                }
                Text("\(viewStore.state.count)")

                Button {
                    viewStore.send(.increment)
                } label: {
                    Text("+")
                }
            }
        }

    }
}
