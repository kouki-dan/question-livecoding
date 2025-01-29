//
//  Network.swift
//  Question
//
//  Created by kouki_dan on 2025/01/29.
//

import Foundation
import Apollo
class Network {
    static let shared = Network()

    private(set) lazy var apollo: ApolloClient = {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(client: client, store: store)
        let url = URL(string: "https://question-camp20250119.hatelabo.jp/api/graphql")!
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
        return ApolloClient(networkTransport: transport, store: store)
    }()
}
class AuthorizationInterceptor: ApolloInterceptor {
    public var id: String = UUID().uuidString
    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation : GraphQLOperation {
        Task {
            do {
                if let accessToken = try await AccountManager.shared.accessToken {
                    request.addHeader(name: "Authorization", value: "Bearer \(accessToken.token)")
                }
                chain.proceedAsync(request: request, response: response, interceptor: self, completion: completion)
            } catch {
                chain.handleErrorAsync(error, request: request, response: response, completion: completion)
            }
        }
    }
}
class NetworkInterceptorProvider: DefaultInterceptorProvider {
    override func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation : GraphQLOperation {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(AuthorizationInterceptor(), at: 0)
        return interceptors
    }
}
