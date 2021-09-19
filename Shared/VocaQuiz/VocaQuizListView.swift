//
//  VocaQuizView.swift
//  Voca
//
//  Created by 강병민 on 2021/09/16.
//

import SwiftUI

struct VocaQuizListView: View {
    @State private var items = ["Paul", "Taylor", "Adele"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack {
                        Text("즐겨찾기")
                        TabView {
                            ForEach(items, id: \.self) { item in
                                NavigationLink(destination: QuizView()) {
                                    CardView {
                                        VocaQuizItemView(title: item,
                                                         count: 34)
                                            .padding()
                                    }
                                }
                            }
                            .padding(20)
                        }
                        .frame(height: 200)
                        .tabViewStyle(PageTabViewStyle())
                        .padding(.bottom)                    }
                    VStack(spacing: 10) {
                        Text("폴더")
                        VStack(spacing: 20) {
                            ForEach(items, id: \.self) { item in
                                NavigationLink(destination: QuizView()) {
                                    CardView {
                                        VocaQuizItemView(title: item,
                                                         count: 34)
                                            .padding()
                                    }
                                }
                                .padding(10)
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("단어 시험")
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            print("VocaList Appeared")
        }
    }
}

struct VocaQuizView_Previews: PreviewProvider {
    static var previews: some View {
        VocaQuizListView()
    }
}

