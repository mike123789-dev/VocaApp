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
                QuizProgressHeader(currentCount: viewStore.currentIndex + 1,
                                   totalCount: viewStore.totalCount)
                Spacer()
                ZStack {
                    ForEach(viewStore.vocas.prefix(3)) { voca in
                        SwipableCardView(
                            content: {
                                VocaCardView(store: .init(initialState: voca, reducer: vocaReducer, environment: .init(mainQueue: .main)))
                            },
                            willSwipeRight: viewStore.binding(\.$willSwipeRight),
                            willSwipeLeft: viewStore.binding(\.$willSwipeLeft),
                            didSwipeRight: nil,
                            didSwipeLeft: nil
                        )
                    }
                }
                Spacer()
                QuizFooter(viewStore: viewStore)
            }
        }
    }
    
    struct QuizProgressHeader: View {
        let currentCount: Int
        let totalCount: Int
        var body: some View {
            VStack {
                Text("\(currentCount)/\(totalCount)")
                ProgressView(value: Double(currentCount), total: Double(totalCount))
                    .frame(width: 150)
            }
        }
    }
    
    struct QuizFooter: View {
        @ObservedObject var viewStore: ViewStore<VocaQuizState, VocaQuizAction>
        var body: some View {
            HStack {
                ScoreView(title: "\(viewStore.wrongCount)", color: .red, isFocused: viewStore.willSwipeLeft)
                Spacer()
                ScoreView(title: "\(viewStore.rightCount)", color: .green, isFocused: viewStore.willSwipeRight)
            }
            .overlay(alignment: .center) {
                Button("재시작") {
                    viewStore.send(.didTapResetButton)
                }
            }
            .padding(.vertical)
        }
    }
    
    struct ScoreView: View {
        let title: String
        let color: Color
        let isFocused: Bool
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(color)
                    .frame(width: isFocused ? 70 : 50, height: 30, alignment: .leading)
                Text(title)
                    .foregroundColor(.white)
            }
            .animation(.interactiveSpring(), value: self.isFocused)
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        VocaQuizView(store: .init(initialState: .init(group: .test1), reducer: vocaQuizReducer, environment: .init()))
    }
}
