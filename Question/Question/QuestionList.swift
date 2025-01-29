//
//  QuestioinList.swift
//  Question
//
//  Created by kouki_dan on 2025/01/29.
//

import SwiftUI

struct QuestionList: View {
    @State var data: GraphQL.QuestionListQuery.Data?

    var body: some View {
        ZStack {
            if let data = data {
                List(data.questions, id: \.id) { question in
                    NavigationLink {
                        QuestionDetail(id: question.id)
                    } label: {
                        Text(question.body)
                    }
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Hatena::Question")
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    NewQuestion()
                } label: {
                    Image(systemName: "plus")
                }
            }
        })
        .task {
            Network.shared.apollo.fetch(query: GraphQL.QuestionListQuery()) {
                self.data = try? $0.get().data
            }
        }
    }
}

#Preview {
}
