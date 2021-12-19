//
//  CardView.swift
//  Voca
//
//  Created by USER on 2021/09/19.
//

import SwiftUI

struct CardView<Content: View>: ContainerView {
    var content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        Group(content: content)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 4)
    }
}

// 4
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView{
            Text("hello")
                .frame(width: 150, height: 150, alignment: .center)
        }
        .frame(height: 400)
        .padding()
    }
}
