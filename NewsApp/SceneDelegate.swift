//
//  SceneDelegate.swift
//  NewsApp
//
//  Created by Nick Sagan on 06.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let nc = UINavigationController(rootViewController: HomeScreenVC())
        nc.navigationBar.backgroundColor = UIColor.white.withAlphaComponent(0)
        nc.navigationBar.tintColor = .white
        window?.rootViewController = nc
        window?.backgroundColor = .systemBlue
        window?.makeKeyAndVisible()
    }
}

