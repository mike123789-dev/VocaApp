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
    var addVocaList: AddVocaListState?
    var newGroup: NewGroupState?
    var isSheetPresented = false
    var isNavigationActive = false
}

extension VocaListState {
    init(list: VocaList) {
        let groups = list.groups
        self.groups = .init(uniqueElements: groups)
    }
}

// MARK: - Action
enum VocaListAction: Equatable {
    case editModeChanged(EditMode)
    case move(IndexSet, Int)
    case group(id: VocaGroup.ID, action: VocaGroupAction)
    case quickAddVoca(QuickAddVocaAction)
    case addVocaList(AddVocaListAction)
    case setSheet(isPresented: Bool)
    case setNavigation(isActive: Bool)
    case newGroup(NewGroupAction)
    case addGroupButonTapped
}

// MARK: - Environment
struct VocaListEnvironment {
    var fileClient: FileClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var backgroundQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
}

extension VocaListEnvironment {
    static let live = Self(fileClient: .live, mainQueue: .main, backgroundQueue: .immediate, uuid: { .init() })
}

// MARK: - Reducer
let vocaListReducer = Reducer<VocaListState, VocaListAction, VocaListEnvironment>.combine(
    vocaGroupReducer.forEach(
        state: \.groups,
        action: /VocaListAction.group(id:action:),
        environment: { .init(mainQueue: $0.mainQueue, uuid: $0.uuid) }
    ),
    newGroupReducer.optional()
        .pullback(
            state: \.newGroup,
            action: /VocaListAction.newGroup,
            environment: { _ in ()}
        ),
    quickAddVocaReducer.optional()
        .pullback(
            state: \.quickAddVoca,
            action: /VocaListAction.quickAddVoca,
            environment: { _ in .init()}
        ),
    addVocaListReducer.optional()
        .pullback(
            state: \.addVocaList,
            action: /VocaListAction.addVocaList,
            environment: { .init(uuid: $0.uuid) }
        ),
    Reducer { state, action, environment in
        switch action {
        case let .editModeChanged(editMode):
            state.editMode = editMode
            return .none
            
        case let .move(source, destination):
            //      state.todos.move(fromOffsets: source, toOffset: destination)
            return .none
            
        case .addGroupButonTapped:
            state.isSheetPresented = true
            state.newGroup = .init()
            return .none
            
        case .newGroup(.confirmButtonTapped):
            guard let title = state.newGroup?.title else { return .none }
            let newGroup = VocaGroup(id: environment.uuid(), title: title)
            state.groups.append(newGroup)
            state.isSheetPresented = false
            state.editMode = .inactive
            return environment.fileClient
                .saveVocaList(vocaList: .init(groups: state.groups.elements), on: environment.backgroundQueue)
                .receive(on: environment.mainQueue)
                .fireAndForget()
            
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
                return environment.fileClient
                    .saveVocaList(vocaList: .init(groups: state.groups.elements), on: environment.backgroundQueue)
                    .receive(on: environment.mainQueue)
                    .fireAndForget()
            default:
                return .none
            }
            
        case .setSheet(isPresented: false):
            state.isSheetPresented = false
            state.newGroup = nil
            state.quickAddVoca = nil
            return .none
            
        case .setNavigation(isActive: true):
            state.isNavigationActive = true
            state.addVocaList = .init(id: environment.uuid(), groups: state.groups.elements)
            return .none
            
        case .setNavigation(isActive: false):
            state.isNavigationActive = false
            state.addVocaList = nil
            return .none
            
        case let .group(id: id, action: action):
            switch action {
            case .addVocaButtonTapped:
                guard let group = state.groups.first(where: {$0.id == id}) else { return .none }
                state.isSheetPresented = true
                state.quickAddVoca = .init(id: environment.uuid(), group: group)
                return .none
                
            default:
                return .none
            }
            
        default:
            return .none
        }
    }
    
)