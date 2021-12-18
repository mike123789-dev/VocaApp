//
//  QuizView.swift
//  Voca
//
//  Created by USER on 2021/09/19.
//

import SwiftUI
import ComposableArchitecture

struct VocaQuizView: View {
    let store: Store<VocaQuizState, VocaQuizAction>
    
    @State var current = 0.0
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                VStack {
                    Text("\(viewStore.currentIndex + 1)/\(viewStore.totalCount)")
                    //                    ProgressView(value: viewStore.currentIndex + 1, total: viewStore.totalCount)
                }
                Spacer()
                VocaCardView(store: .init(initialState: .sample, reducer: vocaReducer, environment: .init(mainQueue: .main)))
                Spacer()
                HStack {
                    Text("\(viewStore.wrongCount)")
                    Spacer()
                    Button("재시작") {
                        
                    }
                    Spacer()
                    Text("\(viewStore.wrongCount)")
                }
                .padding()
            }
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        VocaQuizView(store: .init(initialState: .init(group: .test1), reducer: vocaQuizReducer, environment: .init()))
    }
}
