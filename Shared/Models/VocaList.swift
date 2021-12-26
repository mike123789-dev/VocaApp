//
//  VocaList.swift
//  Voca
//
//  Created by USER on 2021/12/26.
//

import Foundation

struct VocaList: Equatable, Codable {
    var groups: [VocaGroup]
}

extension VocaList {
    
    init() {
        self.groups = []
    }

}
