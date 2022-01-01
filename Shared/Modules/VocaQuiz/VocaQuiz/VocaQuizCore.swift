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
    var originalVocas: [Voca]
    var remainingVocas: [Voca]
    var rightVocas: [Voca] = []
    var wrongVocas: [Voca] = []
    
    @BindableState var willSwipeLeft: Bool = false
    @BindableState var willSwipeRight: Bool = false

    var visableVocas: [Voca] {
        remainingVocas.prefix(3).reversed()
    }
    
    var totalCount: Int
    
    var currentCount: Int {
        totalCount - remainingVocas.count
    }
    
    var rightCount: Int {
        rightVocas.count
    }
    
    var wrongCount: Int {
        wrongVocas.count
    }
    
    var didFinish: Bool {
        return remainingVocas.isEmpty
    }
    
    init(group: VocaGroup) {
        self.title = group.title
        self.totalCount = group.items.count
        self.originalVocas = group.items.elements
        self.remainingVocas = group.items.elements
        self.currentVoca = group.items.elements.first
    }
    
    mutating func restart() {
        self.totalCount = originalVocas.count
        self.remainingVocas = originalVocas
        self.remainingVocas = originalVocas
        self.currentVoca = originalVocas.first
        self.rightVocas = []
        self.wrongVocas = []
    }
    
    mutating func resetWillSwipe() {
        self.willSwipeLeft = false
        self.willSwipeRight = false
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
        state.remainingVocas.removeFirst()
        state.resetWillSwipe()
        switch direction {
        case .left:
            state.wrongVocas.append(voca)
        case .right:
            state.rightVocas.append(voca)
        }
        return .none
    
        
    case .didTapResetButton:
        state.restart()
        return .none
        
    default:
        return .none
    }
}
.binding()
