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
                List {
                    ForEach(viewStore.groups) { item in
                        Section {
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
                                    VStack(alignment: .leading, spacing: 16) {
                                        HStack {
                                            Text("\(item.title)")
                                                .fontWeight(.semibold)
                                            Spacer()
                                            Text("오후 7:24")
                                                .foregroundColor(.secondary)
                                        }
                                        HStack(alignment: .firstTextBaseline) {
                                            Text("\(item.items.count)")
                                                .font(.title)
                                                .fontWeight(.bold)
                                            Text("단어")
                                                .fontWeight(.bold)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.horizontal, 2)
                                    .padding(.vertical, 6)
    //                                CardView {
    //                                    VocaGroupItemView(group: item)
    //                                }
    //                                .padding(.horizontal)
                                })
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
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


/*
 즐겨찾기
 
 VStack {
     Text("즐겨찾기")
     TabView {
         ForEach(viewStore.favoriteGroups) { item in
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
                 })
                 .buttonStyle(PlainButtonStyle())
         }
         .padding(20)
     }
     .frame(height: 200)
     .tabViewStyle(PageTabViewStyle())
     .padding(.bottom)
 }
 */
