//
//  QuizResultView.swift
//  Voca
//
//  Created by USER on 2022/01/01.
//

import SwiftUI
import ComposableArchitecture

struct QuizResultView: View {
    
    @ObservedObject var viewStore: ViewStore<VocaQuizState, VocaQuizAction>
    var correctPercentage: Float {
        let totalCount = Float(viewStore.rightCount + viewStore.wrongCount)
        return Float(viewStore.rightCount) / totalCount
    }
    
    var body: some View {
        VStack {
            ResultStatisticsView(correctCount: viewStore.rightCount,
                                 wrongCount: viewStore.wrongCount,
                                 correctPercentage: correctPercentage)
            
            
            VStack {
                Button {
                    viewStore.send(.didTapResetButton, animation: .spring())
                } label: {
                    Text("재시작")
                        .frame(maxWidth: 200)
                }
                .buttonStyle(BorderedButtonStyle())
                .controlSize(.large)
                .id("RESTART")
                Button {
                    
                } label: {
                    Text("틀린것만 다시")
                        .frame(maxWidth: 200)
                }
                .buttonStyle(BorderedButtonStyle())
                .controlSize(.large)
                Button {
                    viewStore.send(.didTapFinishButton, animation: .spring())
                } label: {
                    Text("완료")
                        .frame(maxWidth: 200)
                }
                .buttonStyle(BorderedButtonStyle())
                .controlSize(.large)

            }
            .padding()
        }
    }
}

struct ResultStatisticsView: View {
    
    let correctCount: Int
    let wrongCount: Int
    let correctPercentage: Float
    
    var body: some View {
        CardView {
            VStack {
                Text("결과")
                    .font(.title)
                    .padding()
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("✅")
                        Text("❌")
                    }
                    VStack(alignment: .trailing, spacing: 20) {
                        Text("\(correctCount)")
                        Text("\(wrongCount)")
                    }
                }
                
                CirclePercentage(percentage: correctPercentage)
                    .frame(maxWidth: 130, maxHeight: 130)
                    .padding()
            }
            .font(.title3)
            .padding(.horizontal, 70)
            .padding(.vertical, 30)
        }
    }
}

struct CirclePercentage: View {
    var percentage: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.percentage, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.red)
                .rotationEffect(Angle(degrees: 270.0))
//                .animation(.linear, value: self.percentage)

            Text(String(format: "%.0f %%", min(self.percentage, 1.0)*100.0))
                .font(.title)
                .bold()
        }
    }
}

struct QuizResultView_Previews: PreviewProvider {
    static var previews: some View {
        QuizResultView(viewStore: .init(.init(initialState: .init(group: .quizTest), reducer: .empty, environment: ())))
    }
}
