//
//  SwipableCardView.swift
//  Voca
//
//  Created by 강병민 on 2021/12/17.
//

import SwiftUI

struct SwipableCardView<Content: View>: View {
    var content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    @State private var translation: CGSize = .zero
    private var thresholdPercentage: CGFloat = 0.3 // when the user has draged 50% the width of the screen in either direction
    var willSwipeRight: (() -> Void)?
    var willSwipeLeft: (() -> Void)?
    var didSwipeRight: (() -> Void)?
    var didSwipeLeft: (() -> Void)?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CardView(content: {
                    content()
                })
                .animation(.interactiveSpring())
                .offset(x: self.translation.width, y: self.translation.height) // 2
                .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.translation = value.translation
                            let percentage = value.translation.width / geometry.size.width
                            if percentage > self.thresholdPercentage {
                                willSwipeRight?()
                            } else if percentage < -self.thresholdPercentage {
                                willSwipeLeft?()
                            }
                            
                        }.onEnded { value in
                            let percentage = value.translation.width / geometry.size.width
                            if percentage > self.thresholdPercentage {
                                didSwipeRight?()
                            } else if percentage < -self.thresholdPercentage {
                                didSwipeLeft?()
                            } else {
                                self.translation = .zero
                            }
                        }
                )
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
    }
}

struct SwipableCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SwipableCardView {
                Text("view")
                    .padding(40)
                    .frame(width: 170, height: 180)
            }
            .offset(x: 0, y: 45)

            SwipableCardView {
                Text("view")
                    .padding(40)
                    .frame(width: 180, height: 180)
            }
            .offset(x: 0, y: 25)
            SwipableCardView {
                Text("view")
                    .padding(40)
                    .frame(width: 200, height: 200)
            }
        }
    }
}
