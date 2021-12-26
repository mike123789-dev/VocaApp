//
//  NewGroupCore.swift
//  Voca
//
//  Created by USER on 2021/12/26.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import ComposableArchitecture

struct NewGroupState: Equatable {
    @BindableState var title: String = ""
    var isValid: Bool {
        return !title.isEmpty
    }
}

enum NewGroupAction: BindableAction, Equatable {
    case binding(BindingAction<NewGroupState>)
    case confirmButtonTapped
}

let newGroupReducer = Reducer<NewGroupState, NewGroupAction, Void> { state, action, _ in
    return .none
}
.binding()
