//
//  ContainerView.swift
//  Voca
//
//  Created by USER on 2021/09/19.
//

import SwiftUI

protocol ContainerView: View {
    associatedtype Content
    init(content: @escaping () -> Content)
}

extension ContainerView {
    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.init(content: content)
    }
}
