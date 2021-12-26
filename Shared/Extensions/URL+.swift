//
//  URL+.swift
//  Voca
//
//  Created by USER on 2021/12/26.
//

import Foundation

extension URL {
    var documentDirectory: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    var vocaListURL: URL? {
        documentDirectory?.appendingPathComponent("")
    }
    
}
