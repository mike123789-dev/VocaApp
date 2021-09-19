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
                        PageView()
                    }
                    VStack(spacing: 8) {
                        Text("폴더")
                        ForEach(items, id: \.self) { item in
                            NavigationLink(destination: QuizView()) {
                                CardView {
                                    VocaQuizItemView(title: item,
                                                     count: 34)
                                        .padding()
                                }
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

struct PageView: View {
    var body: some View {
        TabView {
            ForEach(0..<30) { i in
                ZStack {
                    Color.black
                    Text("Row: \(i)").foregroundColor(.white)
                }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            }
            .padding(.all, 10)
        }
        .frame(width: UIScreen.main.bounds.width, height: 200)
        .tabViewStyle(PageTabViewStyle())
    }
}

