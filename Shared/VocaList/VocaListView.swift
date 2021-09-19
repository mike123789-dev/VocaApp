//
//  ContentView.swift
//  Shared
//
//  Created by 강병민 on 2021/09/16.
//

import SwiftUI

struct VocaListView: View {
    
    @State private var items = ["Paul", "Taylor", "Adele"]
    @State private var isEditMode = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("토익")) {
                    ForEach(items, id: \.self) { item in
                        VocaItemView()
                            .contextMenu{
                                Button("즐겨찾기") {
                                    
                                }
                            }
                    }
                    .onMove(perform: move)
                    .onDelete(perform: { indexSet in
                        removeRows(at: indexSet)
                    })
                }
                Button("toggle edit") {
                    withAnimation {
                        isEditMode.toggle()
                    }
                }
            }
            .navigationBarItems(
                leading:
                    EditButton()
                ,
                trailing:
                    HStack {
                        NavigationLink(destination: AddVocaView()) {
                            Text("단어 추가")
                        }
                    })
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    // 3.
                    if isEditMode {
                        HStack(spacing: 50) {
                            Image(systemName: "trash")
                            Image(systemName: "info")
                            Image(systemName: "paperclip")
                            Text("Share")
                            // 4.
                            HStack {
                                Image(systemName: "photo")
                                Text("Photo")
                            }
                        }
                        
                    }
                }
            }
            .navigationBarTitle("단어장")
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            print("VocaList Appeared")
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        print("source : \(source)")
        print("destination : \(destination)")
        items.move(fromOffsets: source, toOffset: destination)
    }
    
    func removeRows(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
}

struct VocaItemView: View {
    var body: some View {
        HStack {
            Text("Voca Title")
            Spacer()
        }
    }
}

struct VocaListView_Previews: PreviewProvider {
    static var previews: some View {
        VocaListView()
    }
}

