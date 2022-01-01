//
//  CardStackView.swift
//  Voca
//
//  Created by USER on 2022/01/01.
//

import SwiftUI
import ComposableArchitecture

struct CardStackView: View {
    @ObservedObject var viewStore: ViewStore<VocaQuizState, VocaQuizAction>
    let geometry: GeometryProxy
    
    private func getCardWidth(geometry: GeometryProxy, index: Int) -> CGFloat {
        return geometry.size.width * 0.75 + CGFloat(index * 10)
    }

    private func getCardOffset(index: Int) -> CGFloat {
        return -CGFloat(index * 10)
    }

    var body: some View {
        ZStack {
            ForEach(Array(viewStore.visableVocas.enumerated()), id: \.element.self) { (index, voca) in
                SwipableCardView(
                    content: {
                        VocaCardView(store: .init(initialState: voca, reducer: vocaReducer, environment: .init(mainQueue: .main)))
                            .frame(width: self.getCardWidth(geometry: geometry, index: index), height: geometry.size.height * 0.6)
                    },
                    willSwipeRight: viewStore.binding(\.$willSwipeRight),
                    willSwipeLeft: viewStore.binding(\.$willSwipeLeft),
                    didSwipeRight: { viewStore.send(.swipe(voca, direction: .right),
                                                    animation: .spring()) },
                    didSwipeLeft: { viewStore.send(.swipe(voca, direction: .left),
                                                   animation: .spring()) }
                )
                .offset(x: 0, y: self.getCardOffset(index: index))
                .transition(.scale.combined(with: .opacity))
            }
        }

    }
}

struct CardStackView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            CardStackView(viewStore: .init(.init(initialState: .init(group: .quizTest), reducer: .empty, environment: ())), geometry: geometry)
        }
    }
}
