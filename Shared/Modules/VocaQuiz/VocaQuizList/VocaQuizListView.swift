//
//  VocaQuizView.swift
//  Voca
//
//  Created by 강병민 on 2021/09/16.
//

import SwiftUI
import ComposableArchitecture

struct VocaQuizListView: View {
    let store: Store<VocaQuizListState, VocaQuizListAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ScrollView {
                    VStack {
//                        VStack {
//                            Text("즐겨찾기")
//                            TabView {
//                                ForEach(viewStore.favoriteGroups) { item in
//                                    NavigationLink(
//                                        destination: IfLetStore(
//                                            self.store.scope(
//                                                state: \.selection?.value,
//                                                action: VocaQuizListAction.quiz
//                                            ),
//                                            then: { store in
//                                                VocaQuizView(store: store)
//                                            }),
//                                        tag: item.id,
//                                        selection: viewStore.binding(
//                                          get: \.selection?.id,
//                                          send: VocaQuizListAction.setNavigation(selection:)
//                                        ),
//                                        label: {
//                                            CardView {
//                                                VocaGroupItemView(group: item)
//                                            }
//                                        })
//                                        .buttonStyle(PlainButtonStyle())
//                                }
//                                .padding(20)
//                            }
//                            .frame(height: 200)
//                            .tabViewStyle(PageTabViewStyle())
//                            .padding(.bottom)
//                        }
                        VStack(spacing: 10) {
//                            Text("폴더")
                            VStack(spacing: 20) {
                                ForEach(viewStore.groups) { item in
                                    NavigationLink(
                                        destination: IfLetStore(
                                            self.store.scope(
                                                state: \.selection?.value,
                                                action: VocaQuizListAction.quiz
                                            ),
                                            then: { store in
                                                VocaQuizView(store: store)
                                            }),
                                        tag: item.id,
                                        selection: viewStore.binding(
                                          get: \.selection?.id,
                                          send: VocaQuizListAction.setNavigation(selection:)
                                        ),
                                        label: {
                                            CardView {
                                                VocaGroupItemView(group: item)
                                            }
                                            .padding(.horizontal)
                                        })
                                        .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("단어 시험")
                .frame(maxWidth: .infinity)
            }
            .alert(
              self.store.scope(state: \.alert),
              dismiss: .alertDismissed
            )
        }
    }
}

struct VocaQuizView_Previews: PreviewProvider {
    static var previews: some View {
        VocaQuizListView(store: .init(initialState: .init(groups: [.test1]), reducer: vocaQuizListReducer, environment: .init()))
    }
}

