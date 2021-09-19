//
//  VocaQuizView.swift
//  Voca
//
//  Created by 강병민 on 2021/09/16.
//

import SwiftUI

struct VocaQuizView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("VocaQuizView")
            }
            .navigationTitle("단어 시험")
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            print("VocaQuizView Appeared")
        }
    }
}

struct VocaQuizView_Previews: PreviewProvider {
    static var previews: some View {
        VocaQuizView()
    }
}
