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
    
    init(store: Store<VocaListState, VocaListAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: { ViewState(state: $0) }))
    }
    struct ViewState: Equatable {
        var isSheetPresented = false
        var isNavigationActive = false
        var editMode: EditMode = .inactive
        init(state: VocaListState) {
            self.editMode = state.editMode
            self.isNavigationActive = state.isNavigationActive
            self.isSheetPresented = state.isSheetPresented
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEachStore(
                    self.store.scope(state: \.groups, action: VocaListAction.group(id:action:)),
                    content: VocaGroupSectionView.init(store:)
                )
            }
            .navigationBarItems(
                leading:
                    EditButton()
                ,
                trailing:
                    HStack {
                        NavigationLink(destination: IfLetStore(self.store.scope(state: \.addVocaList,
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
                    })
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
            
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    if viewStore.editMode == .active {
                        HStack() {
                            Button("폴더 추가") {
                                viewStore.send(.addGroupButonTapped)
                            }
                            Spacer()
                        }
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            .environment(
                \.editMode,
                 self.viewStore.binding(get: \.editMode, send: VocaListAction.editModeChanged)
            )
            
            .navigationBarTitle("단어장")
        }
        .onAppear {
            print("VocaList Appeared")
        }
    }
    
}


struct VocaListView_Previews: PreviewProvider {
    static var previews: some View {
        VocaListView(store: .init(initialState: .init(groups: [.test1, .init(id: .init(), title: "empty")]), reducer: vocaListReducer, environment: .live))
    }
}

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Button("Press to dismiss") {
            presentationMode.wrappedValue.dismiss()
        }
        .font(.title)
        .padding()
    }
}

struct ContentView: View {
    @State private var showingSheet = false
    
    var body: some View {
        Button("Show Sheet") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            SheetView()
        }
    }
}
