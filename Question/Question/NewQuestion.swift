//
//  NewQuestion.swift
//  Question
//
//  Created by kouki_dan on 2025/01/29.
//

import SwiftUI

struct NewQuestion: View {
    @State var question = ""

    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Section {
                TextField("質問文", text: $question, axis: .vertical)
                    .lineLimit(5...)
            } header: {
                Text("質問する")
            } footer: {
                Button("質問する") {
                    addQuestion()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
    }

    func addQuestion() {
        Network.shared.apollo.perform(mutation: GraphQL.AddQuestionMutation(body: question)) { _ in
            dismiss()
        }
    }
}

#Preview {
    NewQuestion()
}
