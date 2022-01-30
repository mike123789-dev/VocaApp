//
//  ContentView.swift
//  Shared
//
//  Created by 강병민 on 2021/09/16.
//

import SwiftUI
import ComposableArchitecture

struct VocaListView: View {
    
    let store: Store<VocaListState, VocaListAction>
    @ObservedObject var viewStore: ViewStore<ViewState, VocaListAction>
    @Environment(\.editMode) var editMode

    init(store: Store<VocaListState, VocaListAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: { ViewState(state: $0) }))
    }
    
    struct ViewState: Equatable {
        var isSheetPresented = false
        var isNavigationActive = false
        var editMode: EditMode = .inactive
        var query: String
        init(state: VocaListState) {
            self.editMode = state.editMode
            self.isNavigationActive = state.isNavigationActive
            self.isSheetPresented = state.isSheetPresented
            self.query = state.query
        }
    }
    
    var body: some View {
        NavigationView {
            if viewStore.query.isEmpty {
                List {
                    ForEachStore(
                        self.store.scope(state: \.groups, action: VocaListAction.group(id:action:)),
                        content: VocaGroupSectionView.init(store:)
                    )
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        HStack{
                            Button {
                                viewStore.send(.addGroupButonTapped)
                            } label: {
                                Image(systemName: "folder.badge.plus")
                            }
                            Spacer()
                        }
                    }
                }
                .navigationBarTitle("단어장")
                .navigationBarItems(
                    leading: Button (viewStore.editMode == .active ? "완료" : "편집") {
                        viewStore.send(.editModeChanged(viewStore.editMode == .active ? .inactive : .active))
                    },
                    trailing: HStack {
                        NavigationLink(
                            destination: IfLetStore(self.store.scope(
                            state: \.addVocaList,
                            action: VocaListAction.addVocaList),
                                                    then: { store in
                            AddVocaListView(store: store)
                        }),
                                       isActive: viewStore.binding(
                                        get: \.isNavigationActive,
                                        send: VocaListAction.setNavigation(isActive:)
                                       )
                        ) {
                            Button("단어 추가") {
                                viewStore.send(.setNavigation(isActive: true))
                            }
                        }
                    }
                )
            } else {
                List {
                    SimpleGroupSectionView(store: self.store.scope(state: \.searchedVocaGroup, action: VocaListAction.searchVocaGroup))
                }
            }
        }
        .searchable(
            text: viewStore.binding(
                get: \.query,
                send: VocaListAction.queryChanged
            )
        )
        .listStyle(InsetGroupedListStyle())
        .sheet(
            isPresented: viewStore.binding(
                get: \.isSheetPresented,
                send: VocaListAction.setSheet(isPresented:)
            )
        ) {
            IfLetStore(
                self.store.scope(
                    state: \.quickAddVoca,
                    action: VocaListAction.quickAddVoca
                ),
                then: QuickAddVocaView.init(store:)
            )
            IfLetStore(
                self.store.scope(
                    state: \.newGroup,
                    action: VocaListAction.newGroup
                ),
                then: { store in
                    NewGroupView(store: store)
                }
            )
        }
        .environment(
            \.editMode,
            self.viewStore.binding(get: \.editMode, send: VocaListAction.editModeChanged)
        )
    }
    
}


struct VocaListView_Previews: PreviewProvider {
    static var previews: some View {
        VocaListView(store: .init(initialState: .init(groups: [.test1, .init(id: .init(), title: "empty")]), reducer: vocaListReducer, environment: .live))
    }
}
