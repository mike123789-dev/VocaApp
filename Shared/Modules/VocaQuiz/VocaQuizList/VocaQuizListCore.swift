//
//  VocaQuizListCore.swift
//  Voca
//
//  Created by 강병민 on 2021/12/18.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import ComposableArchitecture

// MARK: - State
struct VocaQuizListState: Equatable {
    var favoriteGroups: IdentifiedArrayOf<VocaGroup> = []
    var groups: IdentifiedArrayOf<VocaGroup> = []
    var selection: Identified<VocaGroup.ID, VocaQuizState>?
    var alert: AlertState<VocaQuizListAction>?
}

extension VocaQuizListState {
    
    init(groups: [VocaGroup]) {
        let favorites = groups.filter{ $0.isFavorite == true }
        self.favoriteGroups = .init(uniqueElements: favorites)
        self.groups = .init(uniqueElements: groups)
    }

    init(list: VocaList) {
        let favorites = list.groups.filter{ $0.isFavorite == true }
        self.favoriteGroups = .init(uniqueElements: favorites)
        self.groups = .init(uniqueElements: list.groups)
    }
    
}

// MARK: - Action
enum VocaQuizListAction: Equatable {
    case quiz(VocaQuizAction)
    case setNavigation(selection: UUID?)
    case alertDismissed
}

// MARK: - Environment
struct VocaQuizListEnvironment {
    var fileClient: FileClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var backgroundQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
}

extension VocaQuizListEnvironment {
    static let live = Self(fileClient: .live, mainQueue: .main, backgroundQueue: .immediate, uuid: { .init() })
}

// MARK: - Reducer
let vocaQuizListReducer =
    vocaQuizReducer
    .pullback(
        state: \Identified.value,
        action: .self,
        environment: { $0 }
    )
    .optional()
    .pullback(
      state: \VocaQuizListState.selection,
      action: /VocaQuizListAction.quiz,
        environment: { _ in .init() }
    )
    .combined(with: Reducer<VocaQuizListState, VocaQuizListAction, VocaQuizListEnvironment> { state, action, environment in
        switch action {
        case .quiz(.didTapFinishButton):
            guard let group = state.selection?.group else { return .none }
            state.groups.updateOrAppend(group)
            
            return .merge(
                .init(value: .setNavigation(selection: .none)),
                environment.fileClient
                   .saveVocaList(vocaList: .init(groups: state.groups.elements), on: environment.backgroundQueue)
                   .receive(on: environment.mainQueue)
                   .fireAndForget()
            )
            
        case let .setNavigation(selection: .some(id)):
            guard let selectedGroup = state.groups[id: id] else { return .none }
            if selectedGroup.totalCount > 0 {
                state.selection = .init(.init(group: selectedGroup), id: id)
            } else {
                state.alert = .init(title: .init("단어가 1개 이상인 경우에만 시험을 볼 수 있습니다"),
                                    message: nil,
                                    dismissButton: .default(TextState("확인"), action: .send(.alertDismissed)))
            }
            return .none
            
        case .setNavigation(selection: .none):
            state.selection = nil
            return .none
            
        case .alertDismissed:
            state.alert = nil
            return .none
            
        default:
            return .none
        }
    }
)
