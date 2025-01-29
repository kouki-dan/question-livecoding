// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GraphQL {
  class QuestionListQuery: GraphQLQuery {
    static let operationName: String = "QuestionList"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query QuestionList { questions { __typename id body } }"#
      ))

    public init() {}

    struct Data: GraphQL.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GraphQL.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("questions", [Question].self),
      ] }

      var questions: [Question] { __data["questions"] }

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
        ] }

        var id: GraphQL.ID { __data["id"] }
        var body: String { __data["body"] }
      }
    }
  }

}