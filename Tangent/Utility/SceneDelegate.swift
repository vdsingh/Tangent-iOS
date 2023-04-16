//
//  SceneDelegate.swift
//  Tangent
//
//  Created by Vikram Singh on 3/25/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let mapViewController = TAHomeViewController()
        let navController = UINavigationController()
        navController.setViewControllers([mapViewController], animated: true)
        UINavigationBar.appearance().isTranslucent = false
        window.rootViewController = navController
        window.backgroundColor = .systemBackground
        window.makeKeyAndVisible()
        self.window = window
    }
}

