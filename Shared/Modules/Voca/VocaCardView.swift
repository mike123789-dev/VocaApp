//
//  VocaCardView.swift
//  Voca
//
//  Created by 강병민 on 2021/12/17.
//

import SwiftUI
import ComposableArchitecture

struct VocaCardView: View {
    let store: Store<Voca, VocaAction>
    
    init(store: Store<Voca, VocaAction>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text(viewStore.word)
                    .font(.system(size: 30))
                if viewStore.isShowingMeaning {
                    Text(viewStore.meaning)
                        .foregroundColor(.secondary)
                }
            }
            .padding(50)
            .frame(minWidth: 300, minHeight: 350)
            .contentShape(Rectangle())
            .overlay(
                Button(
                    action: {
                        viewStore.send(.favoriteToggled)
                    },
                    label: {
                        Image(systemName: viewStore.isFavorite ? "star.fill" : "star")
                            .foregroundColor(Color.yellow)
                            .padding(6)
                    }),
                alignment: .topTrailing
            )
            .onTapGesture {
                viewStore.send(.tapped, animation: .easeInOut)
            }
            .overlay(
                HStack {
                    
                },
                alignment: .bottom
            )
        }
    }
}

struct VocaCardView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Spacer()
            VocaCardView(store: .init(initialState: .sample, reducer: vocaReducer, environment: .init(mainQueue: .main)))
            Spacer()
        }
    }
}
