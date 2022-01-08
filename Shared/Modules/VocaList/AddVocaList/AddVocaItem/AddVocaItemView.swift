//
//  AddVocaItemView.swift
//  Voca
//
//  Created by 강병민 on 2021/12/19.
//

import SwiftUI
import ComposableArchitecture

enum Field: Hashable {
  case word
  case meaning
}

struct AddVocaItemView: View {
    private let length = CGFloat(24)
    let store: Store<AddVocaItemState, AddVocaItemAction>
    @FocusState private var focusedField: Field?
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 6) {
                HStack {
                    Group {
                        if viewStore.isFetching {
                            ProgressView()
                                .scaleEffect(0.6)
                                .frame(width: length, height: length, alignment: .center)
                        } else {
                            Spacer()
                        }
                    }
                    Spacer()
                    Group {
                        if !viewStore.isValid {
                            ErrorBadge()
                                .frame(width: length, height: length, alignment: .bottomTrailing)
                        } else {
                            Spacer()
                        }
                    }
                }
                TextField("단어", text: viewStore.binding(\.$addVoca.word))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .word)
                TextField("뜻", text: viewStore.binding(\.$addVoca.meaning))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .meaning)
            }
            .padding()
        }
    }
}

struct AddVocaItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddVocaItemView(store: .init(initialState: .init(id: .init(), addVoca: .init(word: "hello", meaning: ""), isFetching: true), reducer: addVocaItemReducer, environment: .init(mainQueue: .main, client: .init())))
        AddVocaItemView(store: .init(initialState: .init(id: .init(), addVoca: .init(word: "hello", meaning: "안녕"), isFetching: false), reducer: addVocaItemReducer, environment: .init(mainQueue: .main, client: .init())))

    }
}

extension View {
  func synchronize<Value: Equatable>(
    _ first: Binding<Value>,
    _ second: Binding<Value>
  ) -> some View {
    self
      .onChange(of: first.wrappedValue) { second.wrappedValue = $0 }
      .onChange(of: second.wrappedValue) { first.wrappedValue = $0 }
  }

  func synchronize<Value: Equatable>(
    _ first: Binding<Value>,
    _ second: FocusState<Value>.Binding
  ) -> some View {
    self
      .onChange(of: first.wrappedValue) { second.wrappedValue = $0 }
      .onChange(of: second.wrappedValue) { first.wrappedValue = $0 }
  }
}
