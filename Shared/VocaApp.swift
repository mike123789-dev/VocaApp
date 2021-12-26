//
//  VocaApp.swift
//  Shared
//
//  Created by 강병민 on 2021/09/16.
//

import SwiftUI

@main
struct VocaApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(
                store: .init(
                    initialState: .init(),
                    reducer: vocaAppReducer,
                    environment: VocaAppCoreEnvironment(
                        fileClient: .live,
                        mainQueue: .main,
                        uuid: {
                            .init()
                        }
                    )
                )
            )
        }
    }
}
