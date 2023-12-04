//
//  SceneDelegate.swift
//  server-driven-ui
//
//  Created by Василий Клецкин on 11/14/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var viewController: RootWidget!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let rootViewController = makeController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    private func makeController() -> UIViewController {
//        let loader = ExampleLoader()
        let loader = DemoLoader()
        viewController = ScreenComposer.compose(loader: loader)
        viewController.title = "SDUI Demo"
        let updateButton = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(didTapUpdate))
        viewController.navigationItem.rightBarButtonItem = updateButton
        let navController = UINavigationController(rootViewController: viewController)
        
        return navController
    }
    
    @objc func didTapUpdate() {
        viewController.onDidLoad()
    }
}
