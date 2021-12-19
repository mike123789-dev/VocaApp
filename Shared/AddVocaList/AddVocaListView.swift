//
//  AddVocaView.swift
//  Voca
//
//  Created by USER on 2021/09/19.
//

import SwiftUI

struct AddVocaListView: View {
    @State private var items = ["Paul", "Taylor", "Adele"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Spacer()
                        CardView {
                            Text(item)
                                .frame(width: 200, height: 150, alignment: .center)
                        }
                        Spacer()
                    }
                    .onDelete {
                        withAnimation {
                            remove(item: item)
                        }
                    }
                }
                Button("추가") {
                    withAnimation {
                        addItem()
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                // 3.
                HStack {
                    Spacer()
                    Button("카메라") {
                        
                    }
                }
            }
        }
        .navigationBarTitle("단어 추가", displayMode: .inline)
    }
    
    private func addItem() {
        items.append("FOO \(items.count)")
    }
    
    func remove(item: String) {
        items.removeAll(where: {$0 == item})
    }

}

struct AddVocaView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddVocaListView()
        }
    }
}


struct Delete: ViewModifier {
    
    let action: () -> Void
    
    @State var offset: CGSize = .zero
    @State var initialOffset: CGSize = .zero
    @State var contentWidth: CGFloat = 0.0
    @State var willDeleteIfReleased = false
   
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    ZStack {
                        Rectangle()
                            .foregroundColor(.red)
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .font(.title2.bold())
                            .layoutPriority(-1)
                    }.frame(width: -offset.width)
                    .offset(x: geometry.size.width)
                    .onAppear {
                        contentWidth = geometry.size.width
                    }
                    .gesture(
                        TapGesture()
                            .onEnded {
                                delete()
                            }
                    )
                }
            )
            .offset(x: offset.width, y: 0)
            .gesture (
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width + initialOffset.width <= 0 {
                            self.offset.width = gesture.translation.width + initialOffset.width
                        }
                        if self.offset.width < -deletionDistance && !willDeleteIfReleased {
                            hapticFeedback()
                            willDeleteIfReleased.toggle()
                        } else if offset.width > -deletionDistance && willDeleteIfReleased {
                            hapticFeedback()
                            willDeleteIfReleased.toggle()
                        }
                    }
                    .onEnded { _ in
                        if offset.width < -deletionDistance {
                            delete()
                        } else if offset.width < -halfDeletionDistance {
                            offset.width = -tappableDeletionWidth
                            initialOffset.width = -tappableDeletionWidth
                        } else {
                            offset = .zero
                            initialOffset = .zero
                        }
                    }
            )
            .animation(.interactiveSpring())
    }
    
    private func delete() {
        offset.width = -contentWidth
        action()
    }
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    //MARK: Constants
    
    let deletionDistance = CGFloat(200)
    let halfDeletionDistance = CGFloat(50)
    let tappableDeletionWidth = CGFloat(100)
    
    
}

extension View {
    
    func onDelete(perform action: @escaping () -> Void) -> some View {
        self.modifier(Delete(action: action))
    }
    
}
