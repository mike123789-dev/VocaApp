//
//  NewGroupView.swift
//  Voca
//
//  Created by USER on 2021/12/26.
//

import SwiftUI
import ComposableArchitecture

struct NewGroupView: View {
    let store: Store<NewGroupState, NewGroupAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Text("폴더명을 입력해주세요!")
                        .font(.caption)
                    Spacer()
                }
                TextField("", text: viewStore.binding(\.$title))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .labelsHidden()
                Button("추가") {
                    viewStore.send(.confirmButtonTapped)
                }
                .disabled(!viewStore.isValid)
                .padding()
            }
            .padding()
        }
    }
}

struct NewGroupView_Previews: PreviewProvider {
    static var previews: some View {
        NewGroupView(store: .init(initialState: .init(), reducer: newGroupReducer, environment: ()))
    }
}
