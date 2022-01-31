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
    @Environment(\.editMode) var editMode

    init(store: Store<VocaGroup, VocaGroupAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: { ViewState(state: $0) }))
    }
    struct ViewState: Equatable {
        var title: String
        var count: Int
        var isSheetPresented = false
        var isConfirmationDialogPresented: Bool
//        var editMode: EditMode
        init(state: VocaGroup) {
            self.title = state.title
            self.count = state.totalCount
            self.isSheetPresented = state.isSheetPresented
            self.isConfirmationDialogPresented = state.isConfirmationDialogPresented
//            self.editMode = state.editMode
        }
    }
    
    var body: some View {
        Section(
            header: HStack {
                Text(viewStore.title)
                Spacer()
                if let editMode = editMode {
                    if editMode.wrappedValue.isEditing {
                        HStack {
                            Button("삭제") {
                                viewStore.send(.headerDeleteButtonTapped)
                            }
                            Button("수정") {
                                viewStore.send(.modifyButtonTapped)
                            }
                        }
                    } else {
                        Button("빠른 추가") {
                            viewStore.send(.addVocaButtonTapped, animation: .easeInOut)
                        }
                    }
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
                .onMove { viewStore.send(.moveVoca($0, $1)) }
            }
        )
        .sheet(
            isPresented: viewStore.binding(
                get: \.isSheetPresented,
                send: VocaGroupAction.setSheet(isPresented:)
            )
        ) {
            IfLetStore(
                self.store.scope(
                    state: \.modifyVoca,
                    action: VocaGroupAction.modifyVoca
                ),
                then: ModifyVocaView.init(store:)
            )
            IfLetStore(
                self.store.scope(
                    state: \.modifyGroup,
                    action: VocaGroupAction.modifyGroup
                ),
                then: NewGroupView.init(store:)
            )
        }
        .confirmationDialog(
            "Are you sure?",
             isPresented:  viewStore.binding(
                get: \.isConfirmationDialogPresented,
                send: VocaGroupAction.setConfirmationDialog(isPresented:)
            )
        ) {
            Button("삭제", role: .destructive) {
                viewStore.send(.confimationDeleteButtonTapped)
            }
        }

    }
}

struct SimpleGroupSectionView: View {
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
            header: EmptyView(),
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
                .onMove { viewStore.send(.moveVoca($0, $1)) }
            }
        )
    }
}

struct VocaGroupView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            VocaGroupSectionView(store: .init(initialState: .test1, reducer: vocaGroupReducer, environment: .init(mainQueue: .main, uuid: { .init()})))
            
            SimpleGroupSectionView(store: .init(initialState: .test1, reducer: vocaGroupReducer, environment: .init(mainQueue: .main, uuid: { .init()})))

        }
        .listStyle(InsetGroupedListStyle())
    }
}
 
