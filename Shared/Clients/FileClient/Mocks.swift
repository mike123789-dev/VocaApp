//
//  Mocks.swift
//  Voca
//
//  Created by USER on 2021/12/26.
//

import Combine
import ComposableArchitecture

extension FileClient {
  public static let noop = Self(
    delete: { _ in .none },
    load: { _ in .none },
    save: { _, _ in .none }
  )

  #if DEBUG
    public static let failing = Self(
        delete: { .failing("\(Self.self).delete(\($0)) is unimplemented") },
      load: { .failing("\(Self.self).load(\($0)) is unimplemented") },
      save: { file, _ in .failing("\(Self.self).save(\(file)) is unimplemented") }
    )
  #endif

}
