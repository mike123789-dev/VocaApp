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
    var currentGroup: VocaGroup
    var addVocas: IdentifiedArrayOf<AddVocaItemState>
    var alert: AlertState<AddVocaListAction>?

    var isAllValidate: Bool {
        return addVocas.map{ $0.isValid }.allSatisfy({$0})
    }
}

extension AddVocaListState {
    static let mock = Self(id: .init(), groups: [.test1, .quizTest, .empty])
    init(id: UUID, groups: [VocaGroup]) {
        let first = AddVocaItemState(id: id)
        self.addVocas = .init()
        self.addVocas.append(first)
        self.groups = groups
        self.currentGroup = groups.first! // 최소 한개의 그룹은 있다고 가정
    }
}

// MARK: - Action
enum AddVocaListAction: Equatable {
    case selectGroup(VocaGroup)
    case addVoca(id: AddVocaItemState.ID, action: AddVocaItemAction)
    case delete(IndexSet)
    case addButtonTapped
    case confirmButtonTapped
    case alertDismissed
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
            
        case let .selectGroup(group):
            state.currentGroup = group
            return .none
            
        case .confirmButtonTapped:
            if !state.isAllValidate {
                state.alert = .init(title: .init("비어있는 칸이 있습니다"),
                                    message: .init("이동합니다"),
                                    dismissButton: .default(TextState("확인"), action: .send(.alertDismissed)))
            }
            return .none
            
        case .alertDismissed:
            state.alert = nil
            if let index = state.addVocas.firstIndex(where: { !$0.isValid }) {
                print("😢 비어있는 index: \(index)")
            }
            // scroll 해주기
            return .none

        }
    }
)
