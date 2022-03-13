//
//  MainView.swift
//  Voca
//
//  Created by 강병민 on 2021/09/16.
//

import SwiftUI
import ComposableArchitecture

struct VocaAppView: View {
    let store: Store<VocaAppState, VocaAppAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            TabView(
                selection: .init(
                    get: { viewStore.tab },
                    set: { viewStore.send(.tabSelected($0)) }
                )
            ) {
                VocaListView(store: self.store.scope(state: \.vocaList, action: VocaAppAction.vocaList))
                    .tabItem {
                        Label("단어", systemImage: "list.dash")
                    }
                    .tag(AppTab.list)
                VocaQuizListView(store: self.store.scope(state: \.vocaQuizList, action: VocaAppAction.vocaQuizList))
                    .tabItem {
                        Label("시험", systemImage: "square.stack.fill")
                    }
                    .tag(AppTab.quiz)
            }
            .onAppear {
                viewStore.send(.viewAppeared)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        VocaAppView(store: .init(initialState: .init(), reducer: vocaAppReducer, environment: VocaAppCoreEnvironment(fileClient: .live, mainQueue: .main, backgroundQueue: DispatchQueue(label: "background-queue").eraseToAnyScheduler(), uuid: {
            .init()
        })))
//            .preferredColorScheme(.dark)
    }
}
