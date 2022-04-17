//
//  SwipableCardView.swift
//  Voca
//
//  Created by 강병민 on 2021/12/17.
//

import SwiftUI

struct SwipableCardView<Content: View>: View {
    var content: () -> Content

    init(
        @ViewBuilder content: @escaping () -> Content,
        willSwipeRight: Binding<Bool>,
        willSwipeLeft:  Binding<Bool>,
        didSwipeRight: (() -> Void)? = nil,
        didSwipeLeft: (() -> Void)? = nil
    ) {
        self.content = content
        self._willSwipeLeft = willSwipeLeft
        self._willSwipeRight = willSwipeRight
        self.didSwipeLeft = didSwipeLeft
        self.didSwipeRight = didSwipeRight
    }

    @State private var translation: CGSize = .zero
    @Binding var willSwipeRight: Bool
    @Binding var willSwipeLeft: Bool
    private var thresholdPercentage: CGFloat = 0.3
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
                                self.willSwipeRight = true
                                print("willSwipeRight")
                            } else if percentage < -self.thresholdPercentage {
                                self.willSwipeLeft = true
                                print("willSwipeLeft")
                            } else {
                                self.willSwipeRight = false
                                self.willSwipeLeft = false
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
    
    struct WrapperView: View {
        @State var left = false
        @State var right = false
        var body: some View {
            SwipableCardView(content: {
                Text("view")
                    .padding(40)
                    .frame(width: 170, height: 180)
            }, willSwipeRight: $left, willSwipeLeft: $right, didSwipeRight: nil, didSwipeLeft: nil)
        }
    }
    
    static var previews: some View {
        ZStack {
            WrapperView()
                .offset(x: 0, y: 45)
            
            WrapperView()
                .offset(x: 0, y: 25)
            
            WrapperView()
        }
    }
}
