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
    
    
    var body: some View {
        GeometryReader { geometry in
            WithViewStore(store) { viewStore in
                VStack {
                    QuizProgressHeader(currentCount: viewStore.currentCount,
                                       totalCount: viewStore.totalCount)
                    Spacer()
                    if viewStore.didFinish {
                        QuizResultView(viewStore: viewStore)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .transition(.move(edge: .bottom))
                    } else {
                        CardStackView(viewStore: viewStore, geometry: geometry)
                        Spacer()
                        QuizFooter(viewStore: viewStore)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Text(viewStore.title)
                                .font(.headline)
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
        }
    }
    
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Group {
                VocaQuizView(store: .init(initialState: .init(group: .onlyOne), reducer: vocaQuizReducer, environment: .init()))
                VocaQuizView(store: .init(initialState: .init(group: .onlyOne), reducer: vocaQuizReducer, environment: .init()))
                    .previewDevice("iPhone SE (2nd generation)")
            }
        }
    }
}
