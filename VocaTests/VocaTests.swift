//
//  VocaTests.swift
//  VocaTests
//
//  Created by USER on 2022/01/05.
//
import ComposableArchitecture
import XCTest
@testable import Voca

class VocaTests: XCTestCase {
    let scheduler = DispatchQueue.test

    func testVocaToggleFavorite() {
        let voca = Voca(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            word: "word",
            meaning: "meaning"
        )
        let store = TestStore(
            initialState: voca,
            reducer: vocaReducer,
            environment: VocaEnvironment(mainQueue: self.scheduler.eraseToAnyScheduler())
        )
        store.send(.favoriteToggled) {
            $0.isFavorite = true
        }
    }
    
    func testVocaToggleIsShowingMeaning() {
        let voca = Voca(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            word: "word",
            meaning: "meaning"
        )
        let store = TestStore(
            initialState: voca,
            reducer: vocaReducer,
            environment: VocaEnvironment(mainQueue: self.scheduler.eraseToAnyScheduler())
        )
        store.send(.tapped) {
            $0.isShowingMeaning = true
        }
        self.scheduler.advance(by: 2)
        store.receive(.stopShowingMeaning) {
            $0.isShowingMeaning = false
        }
    }

    
    func testAddVocaGroupToList() {
        let emptyGroup = VocaGroup(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            title: "First"
        )
        let store = TestStore(
            initialState: emptyGroup,
            reducer: vocaGroupReducer,
            environment: VocaGroupEnvironment(mainQueue: self.scheduler.eraseToAnyScheduler(), uuid: UUID.incrementing)
        )
    }

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
