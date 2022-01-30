//
//  ModifyVocaCore.swift
//  Voca
//
//  Created by USER on 2022/01/30.
//

import SwiftUI
import ComposableArchitecture

// MARK: - State
struct ModifyVocaState: Equatable, Hashable {
    var addVoca: AddVocaItemState
    
    var isFavorite: Bool
    
    var isValid: Bool {
        return addVoca.isValid
    }
    
    var word: String {
        return addVoca.addVoca.word
    }
    
    var meaning: String {
        return addVoca.addVoca.meaning
    }
}

// MARK: - Action
enum ModifyVocaAction: Equatable {
    case addVoca(AddVocaItemAction)
    case confirmButtonTapped
    case cancelButtonTapped
}

// MARK: - Environment
struct ModifyVocaEnvironment {
    // var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - Reducer
let modifyVocaReducer = Reducer<ModifyVocaState, ModifyVocaAction, ModifyVocaEnvironment>.combine(
    addVocaItemReducer.pullback(state: \.addVoca,
                                action: /ModifyVocaAction.addVoca,
                                environment: { _ in .init(mainQueue: .main, client: .init()) })
)

struct ModifyVocaView: View {
    let store: Store<ModifyVocaState, ModifyVocaAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text("단어를 수정합니다")
                    .padding()
                AddVocaItemView(store: self.store.scope(state: \.addVoca,
                                                        action: ModifyVocaAction.addVoca))
                HStack {
                    Button("취소") {
                        viewStore.send(.cancelButtonTapped)
                    }
                    .keyboardShortcut(.cancelAction)
                    Button("확인") {
                        viewStore.send(.confirmButtonTapped)
                    }
                    .disabled(!viewStore.isValid)
                    .keyboardShortcut(.defaultAction)
                }
                .buttonStyle(BorderedButtonStyle())
                .padding()
            }
            .padding()
        }
    }
}

struct ModifyVocaView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ModifyVocaView(store: .init(initialState: .init(addVoca: .init(id: .init()), isFavorite: true),
                                      reducer: modifyVocaReducer,
                                      environment: .init()))
    }
}
