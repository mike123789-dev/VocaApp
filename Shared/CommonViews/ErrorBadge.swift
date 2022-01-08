//
//  ErrorBadget.swift
//  Voca
//
//  Created by USER on 2022/01/08.
//

import SwiftUI

struct ErrorBadge: View {
    private let length: CGFloat = 10
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.red)
            .frame(width: length, height: length, alignment: .center)
    }
}

struct ErrorBadge_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .trailing) {
            ErrorBadge()
                .frame(width: 16, height: 16, alignment: .bottomTrailing)
            TextField("", text: .constant("some value"))
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
    }
}
