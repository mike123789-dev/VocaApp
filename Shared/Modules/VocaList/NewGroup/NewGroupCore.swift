//
//  NewGroupCore.swift
//  Voca
//
//  Created by USER on 2021/12/26.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import ComposableArchitecture

struct NewGroupState: Equatable, Hashable {
    enum Mode {
        case new, modify
    }
    let mode: Mode
    @BindableState var title: String = ""
    var isValid: Bool {
        return !title.isEmpty
    }
}

extension NewGroupState {
    init(title: String, mode: Mode = .new) {
        self.title = title
        self.mode = mode
    }
}

enum NewGroupAction: BindableAction, Equatable {
    case binding(BindingAction<NewGroupState>)
    case confirmButtonTapped
    case cancelButtonTapped
}

let newGroupReducer = Reducer<NewGroupState, NewGroupAction, Void> { state, action, _ in
    return .none
}
.binding()
