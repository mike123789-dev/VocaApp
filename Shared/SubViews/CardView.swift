//
//  CardView.swift
//  Voca
//
//  Created by USER on 2021/09/19.
//

import SwiftUI

struct CardView<Content: View>: ContainerView {
    var content: () -> Content
    
    var body: some View {
        Group(content: content)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

// 4
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView{
            Text("hello")
                .frame(width: 100, height: 100, alignment: .center)
        }
        .frame(height: 400)
        .padding()
    }
}
