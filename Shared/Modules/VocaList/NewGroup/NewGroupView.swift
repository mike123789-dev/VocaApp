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
                HStack {
                    Button("취소") {
                        viewStore.send(.cancelButtonTapped)
                    }
                    .keyboardShortcut(.cancelAction)
                    Button(viewStore.mode == .new ? "추가" : "수정") {
                        viewStore.send(.confirmButtonTapped)
                    }
                    .disabled(!viewStore.isValid)
                    .keyboardShortcut(.defaultAction)
                }
                .buttonStyle(BorderedButtonStyle())
                .padding()
            }
            .padding()
        }
    }
}

struct NewGroupView_Previews: PreviewProvider {
    static var previews: some View {
        NewGroupView(store: .init(initialState: .init(title: "FOO"), reducer: newGroupReducer, environment: ()))
    }
}
