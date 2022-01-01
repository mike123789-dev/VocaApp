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
                    CardStackView(viewStore: viewStore, geometry: geometry)
                    Spacer()
                    QuizFooter(viewStore: viewStore)
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
//        .edgesIgnoringSafeArea(.all)
    }
    
    struct QuizProgressHeader: View {
        let currentCount: Int
        let totalCount: Int
        var body: some View {
            VStack {
                Text("\(currentCount) / \(totalCount)")
                ProgressView(value: Double(currentCount), total: Double(totalCount))
                    .frame(width: 150)
                    .animation(.interactiveSpring(), value: currentCount)
            }
        }
    }
    
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
    
    struct QuizFooter: View {
        @ObservedObject var viewStore: ViewStore<VocaQuizState, VocaQuizAction>
        var body: some View {
            HStack {
                ScoreView(title: "\(viewStore.wrongCount)", position: .left, isFocused: viewStore.willSwipeLeft)
                Spacer()
                ScoreView(title: "\(viewStore.rightCount)", position: .right, isFocused: viewStore.willSwipeRight)
            }
            .overlay(alignment: .center) {
                Button("재시작") {
                    viewStore.send(.didTapResetButton, animation: .spring())
                }
            }
            .padding(.vertical)
        }
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
                    .frame(width: isFocused ? 60 : 50, height: 30, alignment: .leading)
                    .cornerRadius(2, corners: position.corners)
                Text(title)
                    .foregroundColor(.white)
            }
            .animation(.interactiveSpring(), value: self.isFocused)
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Group {
                VocaQuizView(store: .init(initialState: .init(group: .quizTest), reducer: vocaQuizReducer, environment: .init()))
                VocaQuizView(store: .init(initialState: .init(group: .quizTest), reducer: vocaQuizReducer, environment: .init()))
                    .previewDevice("iPhone SE (2nd generation)")
            }
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
