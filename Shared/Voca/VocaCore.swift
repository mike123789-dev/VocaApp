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
    var isShowingMeaning = false // 얘는 따로 빼놔야하나?
    private var correctCount = 0
    private var wrongCount = 0
    
    var totalCount: Int {
        correctCount + wrongCount
    }
    
    var correctAnswerRate: Double {
        Double(correctCount)/Double(totalCount)
    }
        
    mutating func answerWrong() {
        wrongCount += 1
    }
    mutating func answerCorrect() {
        correctCount += 1
    }

}

extension Voca {
    static let sample = Voca(id: .init(), word: "Sample", meaning: "샘플")
    static let favorite = Voca(id: .init(), word: "Favorited", meaning: "푸", isFavorite: true, isShowingMeaning: false)
    static let highlighted = Voca(id: .init(), word: "Highlighted", meaning: "하이라이트", isFavorite: true, isShowingMeaning: true)
}

extension Voca {
    init(id: UUID, word: String, meaning: String) {
        self.id = id
        self.word = word
        self.meaning = meaning
    }
}

// MARK: - Action
enum VocaAction: Equatable {
    case tapped
    case wordTextChanged(String)
    case meaningTextChanged(String)
    case favoriteToggled
    case stopShowingMeaning
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
        state.isShowingMeaning.toggle()
        if state.isShowingMeaning {
            return Effect(value: .stopShowingMeaning)
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
        
    case .stopShowingMeaning:
        state.isShowingMeaning = false
        return .none
    }
}
