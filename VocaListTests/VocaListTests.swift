//
//  VocaListTests.swift
//  VocaListTests
//
//  Created by USER on 2022/01/08.
//
import ComposableArchitecture
import XCTest
@testable import Voca

class VocaListTests: XCTestCase {
    let scheduler = DispatchQueue.test
    
    func testAddVocaGroups() {
        let store = TestStore(
            initialState: VocaListState(list: .init(groups: [])),
            reducer: vocaListReducer,
            environment: .init(
                fileClient: .noop,
                mainQueue: .immediate,
                backgroundQueue: .immediate,
                uuid: UUID.incrementing
            )
        )
        store.send(.addGroupButonTapped) {
            $0.isSheetPresented = true
            $0.newGroup = .init()
        }
        store.send(.newGroup(.set(\.$title, "NEW"))) {
            $0.newGroup?.title = "NEW"
        }
        store.send(.newGroup(.confirmButtonTapped)) {
            $0.isSheetPresented = false
            $0.newGroup = nil
            $0.groups = [.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, title: "NEW")]
        }
        store.send(.addGroupButonTapped) {
            $0.isSheetPresented = true
            $0.newGroup = .init()
        }
        store.send(.newGroup(.set(\.$title, "NEW"))) {
            $0.newGroup?.title = "NEW"
        }
        store.send(.newGroup(.confirmButtonTapped)) {
            $0.isSheetPresented = false
            $0.newGroup = nil
            $0.groups = [
                .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, title: "NEW"),
                .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, title: "NEW")
            ]
        }
    }
    
    func testAddVocaWithQuickAddVoca() {
        let store = TestStore(
            initialState: VocaListState(list: .init(groups: [])),
            reducer: vocaListReducer,
            environment: .init(
                fileClient: .noop,
                mainQueue: .immediate,
                backgroundQueue: .immediate,
                uuid: UUID.incrementing
            )
        )
        store.send(.addGroupButonTapped) {
            $0.isSheetPresented = true
            $0.newGroup = .init()
        }
        store.send(.newGroup(.set(\.$title, "NEW"))) {
            $0.newGroup?.title = "NEW"
        }
        store.send(.newGroup(.confirmButtonTapped)) {
            $0.isSheetPresented = false
            $0.newGroup = nil
            $0.groups = [.init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, title: "NEW")]
        }
        store.send(.group(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, action: .addVocaButtonTapped)) {
            $0.isSheetPresented = true
            $0.quickAddVoca = .init(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                group: .init(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, title: "NEW")
            )
        }
        store.send(.quickAddVoca(.addVoca(.set(\.$addVoca.word, "FOO")))) {
            $0.quickAddVoca?.addVoca.addVoca.word = "FOO"
        }
        store.send(.quickAddVoca(.addVoca(.set(\.$addVoca.meaning, "BAR")))) {
            $0.quickAddVoca?.addVoca.addVoca.meaning = "BAR"
        }
        store.send(.quickAddVoca(.confirmButtonTapped)) {
            $0.isSheetPresented = false
            $0.quickAddVoca = nil
            $0.groups[id: $0.groups[0].id]?.items = .init(uniqueElements: [.init(id:  UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, word: "FOO", meaning: "BAR")])
        }
    }

}

extension Voca {
    static let voca1 = Voca(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
        word: "voca1",
        meaning: "voca1"
    )
    static let voca2 = Voca(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
        word: "voca2",
        meaning: "voca2"
    )
    static let voca3 = Voca(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
        word: "voca3",
        meaning: "voca3"
    )
}

extension VocaGroup {
    static let testGroup = VocaGroup(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
        title: "test",
        items: .init(uniqueElements: [.voca1, .voca2, .voca3]),
        isFavorite: false
    )
}

extension VocaList {
    static let testList = VocaList(groups: [.testGroup])
}

extension UUID {
  // A deterministic, auto-incrementing "UUID" generator for testing.
  static var incrementing: () -> UUID {
    var uuid = 0
    return {
      defer { uuid += 1 }
      return UUID(uuidString: "00000000-0000-0000-0000-\(String(format: "%012x", uuid))")!
    }
  }
}
