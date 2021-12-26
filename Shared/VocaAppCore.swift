//
//  VocaAppCoreCore.swift
//  Voca
//
//  Created by USER on 2021/12/25.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import ComposableArchitecture

// MARK: - State
struct VocaAppState: Equatable {
    
    var isFetching: Bool = true
    var vocaList: VocaListState = .init(groups: [])
    var vocaQuizList: VocaQuizListState = .init(groups: [])
    
    init() {
    }
}

// MARK: - Action
enum VocaAppAction: Equatable {
    case viewAppeared
    case vocaListLoaded(Result<VocaList, NSError>)
    case vocaList(VocaListAction)
    case vocaQuizList(VocaQuizListAction)
}

// MARK: - Environment
struct VocaAppCoreEnvironment {
    var fileClient: FileClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
}

// MARK: - Reducer
let vocaAppReducer = Reducer<VocaAppState, VocaAppAction, VocaAppCoreEnvironment>.combine(
    vocaListReducer
        .pullback(
            state: \.vocaList,
            action: /VocaAppAction.vocaList,
            environment: { .init(fileClient: $0.fileClient, mainQueue: $0.mainQueue, uuid: $0.uuid) }
        ),
    vocaQuizListReducer
        .pullback(
            state: \.vocaQuizList,
            action: /VocaAppAction.vocaQuizList,
            environment: { _ in .init() }
        ),
    Reducer { state, action, environment in
        switch action {
        case .viewAppeared:
            return environment.fileClient
                .loadVocaList()
                .map(VocaAppAction.vocaListLoaded)
            
        case let .vocaListLoaded(list):
            guard let list = try? list.get() else { return .none }
            print("😍 Voca List Loaded!")
            state.vocaList = .init(list: list)
            state.vocaQuizList = .init(list: list)
            return .none
            
        default:
            return .none
        }
    }
)
