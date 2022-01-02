//
//  QuizProgressHeader.swift
//  Voca
//
//  Created by USER on 2022/01/01.
//

import SwiftUI
import ComposableArchitecture

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

struct QuizProgressHeader_Previews: PreviewProvider {
    static var previews: some View {
        QuizProgressHeader(currentCount: 5, totalCount: 10)
    }
}
