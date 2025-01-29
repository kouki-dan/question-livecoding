//
//  AccountManager.swift
//  Question
//
//  Created by kouki_dan on 2025/01/29.
//

import Foundation
import AuthenticationServices
import HatenaOAuth2
@MainActor
class AccountManager {
    static let shared = AccountManager()
    private let OAuth2: HatenaOAuth2
    var authorized: Bool {
        get async {
            if let accounts = try? await OAuth2.accounts {
                !accounts.isEmpty
            } else {
                false
            }
        }
    }
    var accessToken: AccessToken? {
        get async throws {
            if let account = try await OAuth2.accounts.first {
                return try await OAuth2[account]?.accessToken
            } else {
                return nil
            }
        }
    }
    init() {
        let oauth = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "OAuth", ofType: "plist")!)!
        self.OAuth2 = HatenaOAuth2(
            issuer: URL(string: "https://accounts.hatena.ne.jp")!,
            clientID: oauth["clientId"] as? String ?? "",
            clientSecret: oauth["clientSecret"] as? String ?? "",
            scopes: ["profile", "hatenaid-demo.hatelabo.jp/hatenaid-demo:read", "hatenaid-demo.hatelabo.jp/hatenaid-demo:write"],
            redirectURL: URL(string: "question-camp20250119://oauth-callback")!,
            storage: KeychainStorage(server: "accounts.hatena.ne.jp")
        )
    }
    func authorize(presentationContextProvider: ASWebAuthenticationPresentationContextProviding) async throws {
        if try await OAuth2.accounts.isEmpty {
            _ = try await OAuth2.authorize(presentationContextProvider: presentationContextProvider)
        } else {
            fatalError("Already authorized")
        }
    }
    func remove() async throws {
        let accounts = try await OAuth2.accounts
        for account in accounts {
            try await OAuth2.revokeAuthorization(of: account)
        }
    }
}
