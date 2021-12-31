//
//  AddVocaListCore.swift
//  Voca
//
//  Created by 강병민 on 2021/12/19.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import ComposableArchitecture

// MARK: - State
struct AddVocaListState: Equatable {
    var groups: [VocaGroup]
    var addVocas: IdentifiedArrayOf<AddVocaItemState>
}

extension AddVocaListState {
    init(id: UUID, groups: [VocaGroup]) {
        let first = AddVocaItemState(id: id)
        self.addVocas = .init()
        self.addVocas.append(first)
        self.groups = groups
    }
}

// MARK: - Action
enum AddVocaListAction: Equatable {
    case addVoca(id: AddVocaItemState.ID, action: AddVocaItemAction)
    case delete(IndexSet)
    case addButtonTapped
}

// MARK: - Environment
struct AddVocaListEnvironment {
    var uuid: () -> UUID
}

// MARK: - Reducer
let addVocaListReducer = Reducer<AddVocaListState, AddVocaListAction, AddVocaListEnvironment>.combine(
    addVocaItemReducer.forEach(
        state: \.addVocas,
        action: /AddVocaListAction.addVoca(id: action:),
        environment: { _ in .init(mainQueue: .main, client: .init())}
    ),
    Reducer { state, action, environment in
        switch action {
        case .addButtonTapped:
            state.addVocas.append(.init(id: environment.uuid()))
            return .none
            
        case let .delete(indexSet):
            state.addVocas.remove(atOffsets: indexSet)
            return .none
            
        case .addVoca(id: _, action: _):
            return .none
        }
    }
)
