//
//  SceneDelegate.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let tabBarVC = UITabBarController()
        
        let apiService = APIService()
        let listVM = ListViewModel(apiService: apiService)
        let listVC = UINavigationController(rootViewController: ListViewController(viewModel: listVM))
        let recordVC = UINavigationController(rootViewController: RecordViewController())
        
        listVC.title = "News"
        recordVC.title = "Record"
        
        tabBarVC.setViewControllers([listVC, recordVC], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = .white
        
        guard let items = tabBarVC.tabBar.items else { return }
        items[0].image = UIImage(systemName: "newspaper")
        items[1].image = UIImage(systemName: "square.and.pencil")
        
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
    }
}

