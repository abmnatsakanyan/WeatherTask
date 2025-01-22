//
//  SceneDelegate.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var applicationCoordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let rootController = UINavigationController()
        applicationCoordinator = ApplicationCoordinator(router: Router(rootController: rootController),
                                                        coordinatorFactory: CoordinatorFactory())
        
        applicationCoordinator?.start()
        
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        PermissionManager.shared.checkNotificationPermission()
    }
}
