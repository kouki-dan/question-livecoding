//
//  QuestionDetail.swift
//  Question
//
//  Created by kouki_dan on 2025/01/29.
//

import SwiftUI

struct QuestionDetail: View {
    var id: String

    @State var question: GraphQL.QuestionDetailQuery.Data.Question?

    @State var answer = ""

    @EnvironmentObject var sceneDelegate: SceneDelegate

    var body: some View {
        ZStack {
            if let question = question {
                Form {
                    Section {
                        Text(question.body)
                    }
                    Section {
                        TextField("回答", text: $answer, axis: .vertical)
                            .lineLimit(5...)
                    } header: {
                        Text("あなたの答えを追加")
                    } footer: {
                        Button("答える！") {
                            addAnswer()
                        }
                    }
                    Section {
                        List(question.answers, id: \.id) {
                            Text($0.body)
                        }
                    } header: {
                        Text("みんなの答え")
                    }
                }
            }
        }
        .task {
            fetch()
        }
        
    }
    func fetch() {
        Network.shared.apollo.fetch(query: GraphQL.QuestionDetailQuery(id: id), cachePolicy: .fetchIgnoringCacheData) { result in
            question = try? result.get().data?.question
        }
    }

    func addAnswer() {
        Task {
            let authrized = await AccountManager.shared.authorized
            if authrized {
                Network.shared.apollo.perform(mutation: GraphQL.AddAnswerMutation(questionId: id, body: answer)) { _ in
                    fetch()
                }
            } else {
                try await AccountManager.shared.authorize(presentationContextProvider: sceneDelegate)
                addAnswer()
            }
        }
    }
}

#Preview {
}
