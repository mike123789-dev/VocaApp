//
//  QuizFooter.swift
//  Voca
//
//  Created by USER on 2022/01/01.
//

import SwiftUI
import ComposableArchitecture

struct QuizFooter: View {
    @ObservedObject var viewStore: ViewStore<VocaQuizState, VocaQuizAction>
    var body: some View {
        HStack {
            ScoreView(title: "\(viewStore.wrongCount)", position: .left, isFocused: viewStore.willSwipeLeft)
                .transition(.move(edge: .leading))
            Spacer()
            ScoreView(title: "\(viewStore.rightCount)", position: .right, isFocused: viewStore.willSwipeRight)
                .transition(.move(edge: .trailing))
        }
        .overlay(alignment: .center) {
            Button("재시작") {
                viewStore.send(.didTapResetButton, animation: .spring())
            }
            .id("RESTART")
        }
        .padding(.vertical)
    }
    
    struct ScoreView: View {
        enum Position {
            case left, right
            
            var color: Color {
                switch self {
                case .left:
                    return .red
                case .right:
                    return .green
                }
            }
            
            var corners: UIRectCorner {
                switch self {
                case .left:
                    return [.topRight, .bottomRight]
                case .right:
                    return [.topLeft, .bottomLeft]
                }
            }
        }
        
        let title: String
        let position: Position
        let isFocused: Bool
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(position.color)
                    .frame(width: isFocused ? 60 : 50, height: 35, alignment: .leading)
                    .cornerRadius(3, corners: position.corners)
                Text(title)
                    .foregroundColor(.white)
            }
            .animation(.interactiveSpring(), value: self.isFocused)
        }
    }

}

struct QuizFooter_Previews: PreviewProvider {
    static var previews: some View {
        QuizFooter(viewStore: .init(.init(initialState: .init(group: .quizTest), reducer: .empty, environment: ())))
    }
}
