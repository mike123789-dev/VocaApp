//
//  VocaAppCoreCore.swift
//  Voca
//
//  Created by USER on 2021/12/25.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import ComposableArchitecture

enum AppTab {
    case list, quiz
}

// MARK: - State
struct VocaAppState: Equatable {
    
    var tab: AppTab = .list
    
    var vocaList: VocaListState = .init(groups: [])
    var vocaQuizList: VocaQuizListState = .init(groups: [])
    
    var isFetching: Bool = true
    
    init() {
    }
    
}

// MARK: - Action
enum VocaAppAction: Equatable {
    case viewAppeared
    case tabSelected(AppTab)
    case vocaListLoaded(Result<VocaList, NSError>)
    case vocaList(VocaListAction)
    case vocaQuizList(VocaQuizListAction)
}

// MARK: - Environment
struct VocaAppCoreEnvironment {
    var fileClient: FileClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var backgroundQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
}

// MARK: - Reducer
let vocaAppReducer = Reducer<VocaAppState, VocaAppAction, VocaAppCoreEnvironment>.combine(
    vocaListReducer
        .pullback(
            state: \.vocaList,
            action: /VocaAppAction.vocaList,
            environment: { .init(fileClient: $0.fileClient, mainQueue: $0.mainQueue, backgroundQueue: $0.backgroundQueue, uuid: $0.uuid) }
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
            state.vocaList = .init(list: list)
            state.vocaQuizList = .init(list: list)
            return .none
            
        case let .tabSelected(tab):
            print("🔨 tabSelected : \(tab)")
            // 메모리에 있는 단어 정보 가져오기
            switch tab {
            case .list:
                if state.tab == .quiz {
                    state.vocaList.groups = state.vocaQuizList.groups
                    state.tab = tab
                }
                break
            case .quiz:
                if state.tab == .list {
                    state.vocaQuizList.groups = state.vocaList.groups
                    state.tab = tab
                }
                break
            }
            return .none
            
        default:
            return .none
        }
    }
)
.debugActions("❤️", actionFormat: .labelsOnly, environment: { _ in .init() })
