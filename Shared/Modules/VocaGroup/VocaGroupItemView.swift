//
//  VocaGroupItemView.swift
//  Voca
//
//  Created by 강병민 on 2021/12/18.
//

import SwiftUI

struct VocaGroupItemView: View {
    let group: VocaGroup

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(group.title)
                    .font(.title3)
                Spacer()
                Text("날짜")
            }
            .padding(.bottom, 6)
            VStack(spacing: 10) {
                Text("총 갯수 :\(group.totalCount)")
//                Text("즐겨찾기 갯수 :\(group.favoriteCount)")
//                    .font(.caption)
                Text("🚀")
                HStack {
                    Spacer()
                    Text("70%")
                        .padding(.trailing, 50)
                    Text("80%")
                        .font(.caption)
                    Spacer()
                }
            }
        }
        .padding()
    }
}

struct VocaGroupItemView_Previews: PreviewProvider {
    static var previews: some View {
        CardView {
            VocaGroupItemView(group: .test1)
        }
    }
}
