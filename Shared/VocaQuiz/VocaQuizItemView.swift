//
//  VocaQuizItemView.swift
//  Voca
//
//  Created by USER on 2021/09/19.
//

import SwiftUI

struct VocaQuizItemView: View {
    let title: String
    let count: Int
    var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Text("날짜")
            }
            .padding(.bottom, 6)
            VStack(spacing: 10) {
                Text("총 \(count) 단어")
                Text("🚀")
                HStack {
                    Spacer()
                    Text("70%")
                        .padding(.trailing, 50)
                    Text("80%")
                    Spacer()
                }
            }
        }
    }
}


struct VocaQuizItemView_Previews: PreviewProvider {
    static var previews: some View {
        CardView {
            VocaQuizItemView(title: "텝스", count: 10)
                .padding()
        }
    }
}
