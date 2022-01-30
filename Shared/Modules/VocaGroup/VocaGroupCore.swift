//
//  VocaGroupCore.swift
//  Voca
//
//  Created by 강병민 on 2021/12/17.
//

import SwiftUI
import ComposableArchitecture

struct VocaGroup: Equatable, Identifiable, Hashable {
    let id: UUID
    var title: String
    var items: IdentifiedArrayOf<Voca> = []
    var isFavorite = true
    var modifyVoca: ModifyVocaState? = nil
    var isSheetPresented = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case items
        case isFavorite
    }
    
    var totalCount: Int {
        return items.count
    }
    
    var favoriteCount: Int {
        return items.filter{ $0.isFavorite == true }.count
    }
    
    mutating func add(_ voca: Voca) {
        items.insert(voca, at: 0)
    }
    
    mutating func addMutliple(_ vocas: [Voca]) {
        var elements = items.elements
        elements.insert(contentsOf: vocas, at: 0)
        self.items = .init(uniqueElements: elements)
    }

}

// 필요한 부분만 coding keys로 빼주기
extension VocaGroup: Encodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        items = try values.decode(IdentifiedArrayOf<Voca>.self, forKey: .items)
        isFavorite = try values.decode(Bool.self, forKey: .isFavorite)
    }
}

extension VocaGroup: Decodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(items, forKey: .items)
        try container.encode(isFavorite, forKey: .isFavorite)
    }
}

extension VocaGroup {
    static let test1 = Self(id: .init(), title: "test folder1", items: [.favorite, .highlighted, .sample])
    static let quizTest = Self(id: .init(), title: "quiz", items: [.first, .second, .third, .forth, .sample, .favorite])
    static let onlyOne = Self(id: .init(), title: "onlyOne", items: [.first])
    static let empty = Self(id: .init(), title: "empty", items: [])
}

enum VocaGroupAction: Equatable {
    case addVocaButtonTapped
    case delete(IndexSet)
    case move(IndexSet, Int)
    case voca(id: Voca.ID, action: VocaAction)
    case setSheet(isPresented: Bool)
    case modifyVoca(ModifyVocaAction)
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
    modifyVocaReducer.optional()
        .pullback(
            state: \.modifyVoca,
            action: /VocaGroupAction.modifyVoca,
            environment: { _ in .init()}
        ),
    Reducer { state, action, environment in
        switch action {
        case let .voca(id: id, action: .delete):
            state.items.remove(id: id)
            return .none
            
        case let .voca(id: id, action: .modify):
            guard let selectedVoca = state.items[id: id] else { return .none }
            print("⭐️\(selectedVoca.id)")
            state.modifyVoca = .init(addVoca: .init(id: id, voca: selectedVoca), isFavorite: selectedVoca.isFavorite)
            state.isSheetPresented = true
            return .none
            
        case .modifyVoca(.confirmButtonTapped):
            guard let modified = state.modifyVoca else { return .none }
            let voca = Voca(id: modified.addVoca.id, word: modified.word, meaning: modified.meaning, isFavorite: modified.isFavorite)
            state.items.updateOrAppend(voca)
            state.modifyVoca = nil
            state.isSheetPresented = false
            return .none
            
        case .move(_, _):
            return .none
            
        case .setSheet(isPresented: false), .modifyVoca(.cancelButtonTapped):
            state.isSheetPresented = false
            state.modifyVoca = nil
            return .none

        default:
            return .none
        }
    }
    
)
