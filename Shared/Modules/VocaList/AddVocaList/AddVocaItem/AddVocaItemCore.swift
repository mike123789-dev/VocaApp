//
//  AddVocaItemCore.swift
//  Voca
//
//  Created by 강병민 on 2021/12/19.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import ComposableArchitecture

// MARK: - State
struct AddVocaItemState: Equatable, Identifiable, Hashable {
    let id: UUID
    @BindableState var addVoca = AddVocaModel()
    var isFetching = false
    var isValid: Bool {
        return addVoca.word.count > 0 && addVoca.meaning.count > 0
    }
}

extension AddVocaItemState {
    init(id: UUID, voca: Voca) {
        self.id = id
        self.addVoca = .init(word: voca.word, meaning: voca.meaning)
    }
}

// MARK: - Action
enum AddVocaItemAction: BindableAction, Equatable {
    case binding(BindingAction<AddVocaItemState>)
}

struct VocaNetworkClient {
    
}

// MARK: - Environment
struct AddVocaItemEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var client: VocaNetworkClient
}

// MARK: - Reducer
let addVocaItemReducer = Reducer<AddVocaItemState, AddVocaItemAction, AddVocaItemEnvironment> { state, action, environment in
    switch action {
    case .binding(\.$addVoca.word):
        // debounce 걸어서 네트워크 요청 해주자
        print("update word")
        return .none
        
    case .binding(\.$addVoca.meaning):
        print("update meaning")
        return .none
        
    default:
        return .none
    }
}
.binding()
