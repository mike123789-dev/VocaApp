//
//  MainView.swift
//  Voca
//
//  Created by 강병민 on 2021/09/16.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            VocaListView(store: .init(initialState: .init(groups: [.test1]), reducer: vocaListReducer, environment: .init(mainQueue: .main, uuid: { .init() })))
                .tabItem {
                    Label("단어", systemImage: "list.dash")
                }
            VocaQuizListView(store: .init(initialState: .init(groups: [.test1]), reducer: vocaQuizListReducer, environment: .init()))
                .tabItem {
                    Label("시험", systemImage: "square.stack.fill")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
