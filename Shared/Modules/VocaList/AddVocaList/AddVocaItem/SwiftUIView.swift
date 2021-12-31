//
//  SwiftUIView.swift
//  Voca
//
//  Created by USER on 2021/12/25.
//

import SwiftUI

enum FocusableField: Hashable {
    case email
    case password
}

struct FocuesViews: View {
    var body: some View {
        VStack {
            SimpleFocusView()
            Divider()
            FocusableListView()
        }
    }
}

struct SimpleFocusView: View {
    @State private var name = "Taylor Swift"
    @FocusState var isInputActive: Bool
    
    var body: some View {
        NavigationView {
            TextField("Enter your name", text: $name)
                .textFieldStyle(.roundedBorder)
                .focused($isInputActive)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("Done") {
                            isInputActive = false
                        }
                    }
                }
        }
    }
}

struct Reminder: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
}

enum Focusable: Hashable {
    case none
    case row(Reminder)
}

struct FocusableListView: View {
    @State var reminders: [Reminder] = [.init(title: "Hello"), .init(title: "World"), .init(title: "Foo"), .init(title: "Bar")]
    
    @FocusState var focusedReminder: Focusable?
    
    var body: some View {
        List {
            ForEach($reminders) { $reminder in
                TextField("", text: $reminder.title)
                    .focused($focusedReminder, equals: .row(reminder))
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("print current focused") {
                    if case let .row(id: focusedID) = focusedReminder {
                        print(focusedID)
                    }
                }

                Button("Before") {
                    if case let .row(id: focused) = focusedReminder,
                       let index = reminders.firstIndex(where: { $0 == focused}) {
                        let beforeIndex = reminders.index(before: index)
                        let beforeReminder = reminders[beforeIndex]
                        focusedReminder = .row(beforeReminder)
                    }
                }

                Button("Next") {
                    if case let .row(id: focused) = focusedReminder,
                       let index = reminders.firstIndex(where: { $0 == focused}) {
                        let nextIndex = reminders.index(after: index)
                        let nextReminder = reminders[nextIndex]
                        focusedReminder = .row(nextReminder)
                    }
                }
                
            }
        }
    }
    
    func createNewReminder() {
        reminders.append(.init(title: "NEW"))
    }
    
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleFocusView()
    }
}
