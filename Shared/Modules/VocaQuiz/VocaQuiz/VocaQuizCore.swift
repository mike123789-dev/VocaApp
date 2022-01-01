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
    var currentVoca: Voca?
    var vocas: [Voca]
    var rightVocas: [Voca] = []
    var wrongVocas: [Voca] = []
    
    @BindableState var willSwipeLeft: Bool = false
    @BindableState var willSwipeRight: Bool = false

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
        self.currentVoca = group.items.elements.first
    }
}

// MARK: - Action
enum VocaQuizAction: BindableAction, Equatable {
    enum SwipeDirection {
        case left
        case right
    }
    case willSwipe(direction: SwipeDirection)
    case swipe(_ voca: Voca, direction: SwipeDirection)
    case didTapResetButton
    case binding(BindingAction<VocaQuizState>)
}

// MARK: - Environment
struct VocaQuizEnvironment {
    // var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - Reducer
let vocaQuizReducer = Reducer<VocaQuizState, VocaQuizAction, VocaQuizEnvironment> { state, action, environment in
    switch action {
    case let .willSwipe(direction: direction):
        switch direction {
        case .left:
            state.willSwipeLeft = true
        case .right:
            state.willSwipeRight = true
        }
        return .none
        
    case let .swipe(voca, direction: direction):
        switch direction {
        case .left:
            state.wrongVocas.append(voca)
        case .right:
            state.rightVocas.append(voca)
        }
        return .none
    
    default:
        return .none
    }
}
.binding()
