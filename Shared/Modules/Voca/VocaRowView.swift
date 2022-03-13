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
                if viewStore.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .scaleEffect(0.5)
                        .offset(x: -18, y: 0)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewStore.send(.tapped)
            }
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isSheetPresented,
                    send: VocaAction.setSheet(isPresented:)
                )
            ) {
                Text("TEST")
            }
            .contextMenu(ContextMenu(menuItems: {
                Button("favorite") {
                    viewStore.send(.favoriteToggled, animation: .easeInOut)
                }
            }))
            .if(viewStore.isShowingMeaning, transform: { view in
                withAnimation {
                    view.listRowBackground(Color.yellow.opacity(0.2))
                        .animation(.default, value: viewStore.isShowingMeaning)
                }
            })
            .if(viewStore.opacity > 0.0, transform: { view in
                withAnimation {
                    view.listRowBackground(Color.red.opacity(viewStore.opacity))
                        .animation(.default, value: viewStore.isShowingMeaning)
                }
            })
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button {
                    viewStore.send(.favoriteToggled, animation: .easeInOut)
                } label: {
                    Label("Favorite", systemImage: "star.fill")
                }
                .tint(.yellow)
                
                Button {
                    viewStore.send(.modify, animation: .easeInOut)
                } label: {
                    Text("수정")
                }
                .tint(.blue)

            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    viewStore.send(.delete, animation: .default)
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
            }
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
                VocaRowView(store: .init(initialState: .sample, reducer: vocaReducer, environment: .init(mainQueue: .main)))
                
            }
        }
        .listStyle(InsetGroupedListStyle())

    }
}
