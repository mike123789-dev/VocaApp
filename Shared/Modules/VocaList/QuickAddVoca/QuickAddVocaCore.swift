//
//  QuickAddVocaCore.swift
//  Voca
//
//  Created by 강병민 on 2021/12/17.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import ComposableArchitecture

// MARK: - State
struct QuickAddVocaState: Equatable {
    let group: VocaGroup
    var addVoca: AddVocaItemState
    
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

extension QuickAddVocaState {
    init(id: UUID, group: VocaGroup) {
        self.addVoca = .init(id: id)
        self.group = group
    }
    
    static let empty = QuickAddVocaState(group: .init(id: .init(), title: "filled"), addVoca: .init(id: .init(), addVoca: .init(), isFetching: false))

    static let filled = QuickAddVocaState(group: .init(id: .init(), title: "filled"), addVoca: .init(id: .init(), addVoca: .init(word: "word", meaning: "meaming"), isFetching: false))
}

// MARK: - Action
enum QuickAddVocaAction: Equatable {
    case addVoca(AddVocaItemAction)
    case confirmButtonTapped
    case cancelButtonTapped
}

// MARK: - Environment
struct QuickAddVocaEnvironment {
    // var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - Reducer
let quickAddVocaReducer = Reducer<QuickAddVocaState, QuickAddVocaAction, QuickAddVocaEnvironment>.combine(
    addVocaItemReducer.pullback(state: \.addVoca,
                                action: /QuickAddVocaAction.addVoca,
                                environment: { _ in .init(mainQueue: .main, client: .init()) })
)
