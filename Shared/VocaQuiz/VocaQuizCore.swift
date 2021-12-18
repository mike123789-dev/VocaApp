//
//  VocaQuizCore.swift
//  Voca
//
//  Created by 강병민 on 2021/12/18.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import ComposableArchitecture

// MARK: - State
struct VocaQuizState: Equatable {
    
    let title: String
    
    var currentIndex = 0
    var vocas: [Voca]
    var rightVocas: [Voca] = []
    var wrongVocas: [Voca] = []
    
    var totalCount: Int {
        vocas.count
    }
    
    var rightCount: Int {
        rightVocas.count
    }
    
    var wrongCount: Int {
        wrongVocas.count
    }
    
    init(group: VocaGroup) {
        self.title = group.title
        self.vocas = group.items.elements
    }
}

// MARK: - Action
enum VocaQuizAction: Equatable {
    enum SwipeDirection {
        case left
        case right
    }
    case swipe(_ voca: Voca, direction: SwipeDirection)
}

// MARK: - Environment
struct VocaQuizEnvironment {
    // var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - Reducer
let vocaQuizReducer = Reducer<VocaQuizState, VocaQuizAction, VocaQuizEnvironment> { state, action, environment in
    switch action {
    case let .swipe(voca, direction: direction):
        switch direction {
        case .left:
            state.wrongVocas.append(voca)
        case .right:
            state.rightVocas.append(voca)
        }
        return .none
    }
}
