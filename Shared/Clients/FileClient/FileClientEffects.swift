//
//  FileClientEffects.swift
//  Voca
//
//  Created by USER on 2021/12/26.
//

import Combine
import ComposableArchitecture

extension FileClient {
  func loadVocaList() -> Effect<Result<VocaList, NSError>, Never> {
    self.load(VocaList.self, from: vocaListFileName)
  }

  func saveVocaList(
    vocaList: VocaList, on queue: AnySchedulerOf<DispatchQueue>
  ) -> Effect<Never, Never> {
    self.save(vocaList, to: vocaListFileName, on: queue)
  }
}

let vocaListFileName = "voca-list"
