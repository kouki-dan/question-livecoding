// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GraphQL {
  class AddQuestionMutation: GraphQLMutation {
    static let operationName: String = "AddQuestion"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation AddQuestion($body: String!) { addQuestion(body: $body) { __typename id body } }"#
      ))

    public var body: String

    public init(body: String) {
      self.body = body
    }

    public var __variables: Variables? { ["body": body] }

    struct Data: GraphQL.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GraphQL.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("addQuestion", AddQuestion.self, arguments: ["body": .variable("body")]),
      ] }

      var addQuestion: AddQuestion { __data["addQuestion"] }

      /// AddQuestion
      ///
      /// Parent Type: `Question`
      struct AddQuestion: GraphQL.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GraphQL.Objects.Question }
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