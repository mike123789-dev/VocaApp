//
//  VocaGroupView.swift
//  Voca
//
//  Created by 강병민 on 2021/12/17.
//

import SwiftUI
import ComposableArchitecture

struct VocaGroupSectionView: View {
    let store: Store<VocaGroup, VocaGroupAction>
    @ObservedObject var viewStore: ViewStore<ViewState, VocaGroupAction>
    
    init(store: Store<VocaGroup, VocaGroupAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: { ViewState(state: $0) }))
    }
    struct ViewState: Equatable {
        var title: String
        var count: Int
        var isSheetPresented = false
        init(state: VocaGroup) {
            self.title = state.title
            self.count = state.totalCount
        }
    }
    
    var body: some View {
        Section(
            header: HStack {
                Text(viewStore.title)
                Spacer()
                Button("add") {
                    viewStore.send(.addVocaButtonTapped, animation: .easeInOut)
                }
            },
            footer: HStack {
                Spacer()
                Text("count : \(viewStore.count)")
                Spacer()
            },
            content: {
                ForEachStore(
                    self.store.scope(state: \.items, action: VocaGroupAction.voca(id:action:)),
                    content: VocaRowView.init(store:)
                )
                .onMove { viewStore.send(.move($0, $1)) }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button {
                        //TODO: favorite action 보내기
                    } label: {
                        Label("Favorite", systemImage: "star.fill")
                    }
                    .tint(.yellow)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        //TODO: delete action 보내기
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                }
            }
        )
    }
}

struct VocaGroupView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            VocaGroupSectionView(store: .init(initialState: .test1, reducer: vocaGroupReducer, environment: .init(mainQueue: .main, uuid: { .init()})))
        }
        .listStyle(InsetGroupedListStyle())
    }
}
 
