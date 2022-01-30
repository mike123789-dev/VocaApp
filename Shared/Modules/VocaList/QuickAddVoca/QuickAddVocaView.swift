//
//  QuickAddVocaView.swift
//  Voca
//
//  Created by 강병민 on 2021/12/17.
//

import SwiftUI
import ComposableArchitecture

struct QuickAddVocaView: View {
    let store: Store<QuickAddVocaState, QuickAddVocaAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text(viewStore.group.title)
                    .font(.title2)
                    .padding()
                AddVocaItemView(store: self.store.scope(state: \.addVoca,
                                                        action: QuickAddVocaAction.addVoca))
                HStack {
                    Button("취소") {
                        viewStore.send(.cancelButtonTapped)
                    }
                    Button("확인") {
                        viewStore.send(.confirmButtonTapped)
                    }
                    .disabled(!viewStore.isValid)
                }
                .buttonStyle(BorderedButtonStyle())
                .padding()
            }
            .padding()
        }
    }
}

struct QuickAddVocaView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        QuickAddVocaView(store: .init(initialState: .empty,
                                      reducer: quickAddVocaReducer,
                                      environment: .init()))

        QuickAddVocaView(store: .init(initialState: .filled,
                                      reducer: quickAddVocaReducer,
                                      environment: .init()))
    }
}
