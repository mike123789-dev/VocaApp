//
//  VocaQuizTests.swift
//  VocaQuizTests
//
//  Created by USER on 2022/01/08.
//
import ComposableArchitecture
import XCTest
@testable import Voca

class VocaQuizTests: XCTestCase {
    let scheduler = DispatchQueue.test
    let store = TestStore(
        initialState: VocaQuizState(group: .testGroup),
        reducer: vocaQuizReducer,
        environment: .init()
    )

    func testVocaQuizAllWrong() {
        self.store.send(.swipe(.voca1, direction: .left)) {
            $0.remainingVocas = [.voca2, .voca3]
            $0.wrongVocas = [.voca1]
        }
        self.store.send(.swipe(.voca2, direction: .left)) {
            $0.remainingVocas = [.voca3]
            $0.wrongVocas = [.voca1, .voca2]
        }
        self.store.send(.swipe(.voca3, direction: .left)) {
            $0.remainingVocas = []
            $0.wrongVocas = [.voca1, .voca2, .voca3]
        }
    }
    
    func testVocaQuizAllRight() {
        self.store.send(.swipe(.voca1, direction: .right)) {
            $0.remainingVocas = [.voca2, .voca3]
            $0.rightVocas = [.voca1]
        }
        self.store.send(.swipe(.voca2, direction: .right)) {
            $0.remainingVocas = [.voca3]
            $0.rightVocas = [.voca1, .voca2]
        }
        self.store.send(.swipe(.voca3, direction: .right)) {
            $0.remainingVocas = []
            $0.rightVocas = [.voca1, .voca2, .voca3]
        }
    }
    
    func testVocaQuizReset() {
        self.store.send(.swipe(.voca1, direction: .right)) {
            $0.remainingVocas = [.voca2, .voca3]
            $0.rightVocas = [.voca1]
        }
        self.store.send(.swipe(.voca2, direction: .right)) {
            $0.remainingVocas = [.voca3]
            $0.rightVocas = [.voca1, .voca2]
        }
        self.store.send(.swipe(.voca3, direction: .right)) {
            $0.remainingVocas = []
            $0.rightVocas = [.voca1, .voca2, .voca3]
        }
        self.store.send(.didTapResetButton) {
            $0 = VocaQuizState(group: .testGroup)
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
