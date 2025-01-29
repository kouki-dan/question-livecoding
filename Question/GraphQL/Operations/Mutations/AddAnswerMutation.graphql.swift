// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GraphQL {
  class AddAnswerMutation: GraphQLMutation {
    static let operationName: String = "AddAnswer"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation AddAnswer($questionId: ID!, $body: String!) { addAnswer(questionId: $questionId, body: $body) { __typename id body } }"#
      ))

    public var questionId: ID
    public var body: String

    public init(
      questionId: ID,
      body: String
    ) {
      self.questionId = questionId
      self.body = body
    }

    public var __variables: Variables? { [
      "questionId": questionId,
      "body": body
    ] }

    struct Data: GraphQL.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GraphQL.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("addAnswer", AddAnswer.self, arguments: [
          "questionId": .variable("questionId"),
          "body": .variable("body")
        ]),
      ] }

      var addAnswer: AddAnswer { __data["addAnswer"] }

      /// AddAnswer
      ///
      /// Parent Type: `Answer`
      struct AddAnswer: GraphQL.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GraphQL.Objects.Answer }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", GraphQL.ID.self),
          .field("body", String.self),
        ] }

        var id: GraphQL.ID { __data["id"] }
        var body: String { __data["body"] }
      }
    }
  }

}