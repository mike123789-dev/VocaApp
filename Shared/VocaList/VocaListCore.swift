//
//  VocaListCore.swift
//  Voca
//
//  Created by 강병민 on 2021/12/16.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

// MARK: - State
struct VocaListState: Equatable {
    var editMode: EditMode = .inactive
    var groups: IdentifiedArrayOf<VocaGroup> = []
    var quickAddVoca: QuickAddVocaState?
    var isSheetPresented = false
}

extension VocaListState {
    init(groups: [VocaGroup]) {
        self.groups = .init(uniqueElements: groups)
    }
}

// MARK: - Action
enum VocaListAction: Equatable {
    case editModeChanged(EditMode)
    case move(IndexSet, Int)
    case group(id: VocaGroup.ID, action: VocaGroupAction)
    case quickAddVoca(QuickAddVocaAction)
    case setSheet(isPresented: Bool)
}

// MARK: - Environment
struct VocaListEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
}

// MARK: - Reducer
let vocaListReducer = Reducer<VocaListState, VocaListAction, VocaListEnvironment>.combine(    vocaGroupReducer.forEach(
    state: \.groups,
    action: /VocaListAction.group(id:action:),
    environment: { .init(mainQueue: $0.mainQueue, uuid: $0.uuid) }
),
quickAddVocaReducer.optional()
    .pullback(
        state: \.quickAddVoca,
        action: /VocaListAction.quickAddVoca,
        environment: { _ in .init()}
    ),
Reducer { state, action, environment in
    switch action {
    case let .editModeChanged(editMode):
        state.editMode = editMode
        return .none
        
    case let .move(source, destination):
        //      state.todos.move(fromOffsets: source, toOffset: destination)
        return .none
        
    case .quickAddVoca(let action):
        switch action {
        case .cancelButtonTapped:
            state.isSheetPresented = false
            state.quickAddVoca = nil
            return .none
        case .confirmButtonTapped:
            // TODO: 더 이쁜 방법으로 업데이트 가능?
            guard let quick = state.quickAddVoca,
                  let index = state.groups.index(id: quick.group.id) else { return .none }
            var updatedGroup = state.groups[index]
            updatedGroup.add(.init(id: environment.uuid(), word: quick.word, meaning: quick.meaning))
            state.groups.update(updatedGroup, at: index)
            state.isSheetPresented = false
            state.quickAddVoca = nil
            return .none
        default:
            return .none
        }
        
    case .setSheet(isPresented: false):
        state.isSheetPresented = false
        state.quickAddVoca = nil
        return .none
        
    case let .group(id: id, action: action):
        switch action {
        case .addVocaButtonTapped:
            guard let group = state.groups.first(where: {$0.id == id}) else { return .none }
            state.isSheetPresented = true
            state.quickAddVoca = .init(group: group)
            return .none
            
        default:
            return .none
        }
        
    default:
        return .none
    }
}

)
