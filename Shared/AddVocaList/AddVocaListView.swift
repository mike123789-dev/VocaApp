//
//  AddVocaView.swift
//  Voca
//
//  Created by USER on 2021/09/19.
//

import SwiftUI
import ComposableArchitecture

struct AddVocaListView: View {

    let store: Store<AddVocaListState, AddVocaListAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                ForEachStore(
                    self.store.scope(state: \.addVocas, action: AddVocaListAction.addVoca(id:action:)),
                    content: AddVocaItemView.init(store:)
                )
                .onDelete { viewStore.send(.delete($0)) }
                Button("추가") {
                    viewStore.send(.addButtonTapped, animation: .default)
                }
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
    }
    
}

struct AddVocaView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddVocaListView(store: .init(initialState: .init(groups: [], addVocas: .init(uniqueElements: [.init(id: .init())])), reducer: addVocaListReducer, environment: .init(uuid: {
                .init()
            })))
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
