//
//  VocaGroupCore.swift
//  Voca
//
//  Created by 강병민 on 2021/12/17.
//

import SwiftUI
import ComposableArchitecture

struct VocaGroup: Equatable, Identifiable, Codable {
    let id: UUID
    var title: String
    var items: IdentifiedArrayOf<Voca> = []
    var isFavorite = true
    
    var totalCount: Int {
        return items.count
    }
    
    var favoriteCount: Int {
        return items.filter{ $0.isFavorite == true }.count
    }
    
    mutating func add(_ voca: Voca) {
        items.insert(voca, at: 0)
    }
}

extension VocaGroup {
    static let test1 = Self(id: .init(), title: "test folder1", items: [.favorite, .highlighted, .sample])
}

enum VocaGroupAction: Equatable {
    case addVocaButtonTapped
    case delete(IndexSet)
    case move(IndexSet, Int)
    case voca(id: Voca.ID, action: VocaAction)
}

struct VocaGroupEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
}

let vocaGroupReducer = Reducer<VocaGroup, VocaGroupAction, VocaGroupEnvironment>.combine(
    vocaReducer.forEach(
        state: \.items,
        action: /VocaGroupAction.voca(id:action:),
        environment: { .init(mainQueue: $0.mainQueue) }
    ),
    Reducer { state, action, environment in
        switch action {
        case let .voca(id: id, action: .delete):
            state.items.remove(id: id)
            return .none

        case .move(_, _):
            return .none
            
        default:
            return .none
        }
    }
    
)
