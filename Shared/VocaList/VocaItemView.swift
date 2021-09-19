//
//  VocaItemView.swift
//  Voca
//
//  Created by USER on 2021/09/19.
//

import SwiftUI

struct VocaItemView: View {
    @State private var isHighlighted = false
    var body: some View {
        HStack {
            Text("Voca Title")
            Spacer()
            if isHighlighted {
                Text("뜻")
                    .foregroundColor(.secondary)
            }
        }
        .background(isHighlighted ? Color.yellow : .clear)
        .onTapGesture {
            withAnimation {
                isHighlighted.toggle()
            }
        }
    }
}

struct VocaItemView_Previews: PreviewProvider {
    static var previews: some View {
        VocaItemView()
            .padding()
    }
}
