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
            VStack {
                Form {
                    Picker(
                      "폴더 선택",
                      selection: viewStore.binding(get: \.currentGroup,
                                                   send: AddVocaListAction.selectGroup)
                    ) {
                        ForEach(viewStore.groups) { group in
                            Text(group.title)
                              .tag(group)
                        }
                    }
                }
                .frame(height: 130)
                ScrollView {
                    ForEachStore(
                        self.store.scope(state: \.addVocas, action: AddVocaListAction.addVoca(id:action:)),
                        content: AddVocaItemView.init(store:)
                    )
                    .onDelete { viewStore.send(.delete($0)) }
                    
                    Button {
                        viewStore.send(.addButtonTapped, animation: .default)
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
                .frame(maxHeight: .infinity)

            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("완료") {
                        viewStore.send(.confirmButtonTapped)
                    }
                }

                ToolbarItemGroup(placement: .bottomBar) {
                    HStack {
                        Button("First") {
                            print("Pressed")
                        }

                        Spacer()

                        Button("Second") {
                            print("Pressed")
                        }
                    }
                }
            }
            .navigationBarTitle("단어 추가", displayMode: .inline)
            .alert(
                self.store.scope(state: \.alert),
                dismiss: .alertDismissed
            )
        }
    }
    
}

struct AddVocaView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddVocaListView(store: .init(initialState: .mock, reducer: .empty, environment: ()))
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
