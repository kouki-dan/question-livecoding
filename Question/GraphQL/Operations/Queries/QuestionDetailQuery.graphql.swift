// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GraphQL {
  class QuestionDetailQuery: GraphQLQuery {
    static let operationName: String = "QuestionDetail"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query QuestionDetail($id: ID!) { question(id: $id) { __typename id body answers { __typename id body } } }"#
      ))

    public var id: ID

    public init(id: ID) {
      self.id = id
    }

    public var __variables: Variables? { ["id": id] }

    struct Data: GraphQL.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GraphQL.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("question", Question?.self, arguments: ["id": .variable("id")]),
      ] }

      var question: Question? { __data["question"] }

      /// Question
      ///
      /// Parent Type: `Question`
      struct Question: GraphQL.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GraphQL.Objects.Question }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", GraphQL.ID.self),
          .field("body", String.self),
          .field("answers", [Answer].self),
        ] }

        var id: GraphQL.ID { __data["id"] }
        var body: String { __data["body"] }
        var answers: [Answer] { __data["answers"] }

        /// Question.Answer
        ///
        /// Parent Type: `Answer`
        struct Answer: GraphQL.SelectionSet {
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

}