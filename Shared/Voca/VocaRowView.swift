//
//  VocaItemView.swift
//  Voca
//
//  Created by USER on 2021/09/19.
//

import SwiftUI
import ComposableArchitecture

struct VocaRowView: View {
    let store: Store<Voca, VocaAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack(alignment: .leading) {
                HStack {
                    Text(viewStore.word)
                    Spacer()
                    if viewStore.isShowingMeaning {
                        Text(viewStore.meaning)
                            .foregroundColor(.secondary)
                    }
                }
//                .padding(.leading, 14)
                if viewStore.isFavorite {
                    Image(systemName: "star")
                        .scaleEffect(0.4)
                        .offset(x: -20, y: 0)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewStore.send(.tapped, animation: .easeInOut)
            }
            .contextMenu(ContextMenu(menuItems: {
                Button("favorite") {
                    viewStore.send(.favoriteToggled, animation: .easeInOut)
                }
            }))
            .listRowBackground(viewStore.isShowingMeaning ? Color.yellow.opacity(0.2) : .clear)
        }
    }
}

struct VocaItemView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section(header: Text("Preview")) {
                VocaRowView(store: .init(initialState: .sample, reducer: vocaReducer, environment: .init(mainQueue: .main)))
                VocaRowView(store: .init(initialState: .favorite, reducer: vocaReducer, environment: .init(mainQueue: .main)))
                VocaRowView(store: .init(initialState: .highlighted, reducer: vocaReducer, environment: .init(mainQueue: .main)))
            }
        }
        .listStyle(InsetGroupedListStyle())

    }
}
