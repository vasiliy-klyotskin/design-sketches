//
//  SceneDelegate.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/14/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let rootViewController = makeController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    private func makeController() -> UIViewController {
        let loader = ExampleLoader()
        return ScreenComposer.compose(loader: loader)
    }
}
