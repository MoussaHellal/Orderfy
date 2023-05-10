//
//  MainTabContainerController.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

class MainTabContainerController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    func setupVCs() {
            viewControllers = [
                createNavController(for: OrdersViewController(), title: NSLocalizedString("Orders", comment: ""), image: UIImage(systemName: "menubar.dock.rectangle.badge.record")!),
                createNavController(for: OrdersArchiveViewController(), title: NSLocalizedString("Orders Archive", comment: ""), image: UIImage(systemName: "archivebox.fill")!)
            ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                      title: String,
                                                      image: UIImage) -> UIViewController {
            let navController = UINavigationController(rootViewController: rootViewController)
            navController.tabBarItem.title = title
            navController.tabBarItem.image = image
            navController.navigationBar.prefersLargeTitles = true
            rootViewController.navigationItem.title = title
            return navController
        }
}

