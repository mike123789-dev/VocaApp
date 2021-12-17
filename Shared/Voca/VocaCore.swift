//
//  VocaCore.swift
//  Voca
//
//  Created by 강병민 on 2021/12/16.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import ComposableArchitecture

// MARK: - State
struct Voca: Equatable, Identifiable {
    let id: UUID
    var word: String
    var meaning: String
    var isFavorite = false
    var isHighlighted = false
}

extension Voca {
    static let sample = Voca(id: .init(), word: "Sample", meaning: "샘플")
    static let favorite = Voca(id: .init(), word: "Favorited", meaning: "푸", isFavorite: true, isHighlighted: false)
    static let highlighted = Voca(id: .init(), word: "Highlighted", meaning: "하이라이트", isFavorite: true, isHighlighted: true)
}

// MARK: - Action
enum VocaAction: Equatable {
    case tapped
    case wordTextChanged(String)
    case meaningTextChanged(String)
    case favoriteToggled
    case unHighlight
}

// MARK: - Environment
struct VocaEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - Reducer
let vocaReducer = Reducer<Voca, VocaAction, VocaEnvironment> { state, action, environment in
    switch action {
    case .tapped:
        //TODO: 1초후에 뜻 다시 뜻 숨기기
        state.isHighlighted.toggle()
        if state.isHighlighted {
            return Effect(value: .unHighlight)
                .debounce(id: state.id, for: 1.5, scheduler: environment.mainQueue.animation())
        } else {
            return .none
        }
        
    case .wordTextChanged(let string):
        state.word = string
        return .none
        
    case .meaningTextChanged(let string):
        state.meaning = string
        return .none
        
    case .favoriteToggled:
        state.isFavorite.toggle()
        return .none
        
    case .unHighlight:
        state.isHighlighted = false
        return .none
    }
}


