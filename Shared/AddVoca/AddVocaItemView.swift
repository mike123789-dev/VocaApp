//
//  AddVocaItemView.swift
//  Voca
//
//  Created by 강병민 on 2021/12/19.
//

import SwiftUI
import ComposableArchitecture

struct AddVocaItemView: View {
    private let length = CGFloat(24)
    let store: Store<AddVocaItemState, AddVocaItemAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 6) {
                HStack {
                    Group {
                        if !viewStore.isValid {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.red)
                                .padding(6)
                        } else {
                            Spacer()
                        }
                    }
                    .frame(width: length, height: length, alignment: .center)
                    Spacer()
                    Group {
                        if viewStore.isFetching {
                            ProgressView()
                                .scaleEffect(0.6)
                        } else {
                            Spacer()
                        }
                    }
                    .frame(width: length, height: length, alignment: .center)

                }
                TextField("단어", text: viewStore.binding(\.$addVoca.word))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("뜻", text: viewStore.binding(\.$addVoca.meaning))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
        }
    }
}

struct AddVocaItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddVocaItemView(store: .init(initialState: .init(addVoca: .init(word: "hello", meaning: ""), isFetching: true), reducer: addVocaItemReducer, environment: .init(mainQueue: .main, client: .init())))
        AddVocaItemView(store: .init(initialState: .init(addVoca: .init(word: "hello", meaning: "안녕"), isFetching: false), reducer: addVocaItemReducer, environment: .init(mainQueue: .main, client: .init())))

    }
}
