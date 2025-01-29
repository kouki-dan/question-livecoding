//
//  QuestionApp.swift
//  Question
//
//  Created by kouki_dan on 2025/01/29.
//

import SwiftUI
import AuthenticationServices

@main
struct QuestionApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
class AppDelegate: NSObject, ObservableObject {
}
extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}
class SceneDelegate: NSObject, ObservableObject {
    @Published var window: UIWindow?
}
extension SceneDelegate: UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.window = (scene as? UIWindowScene)?.keyWindow
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        self.window = nil
    }
}
extension SceneDelegate: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return window ?? UIWindow()
    }
}
