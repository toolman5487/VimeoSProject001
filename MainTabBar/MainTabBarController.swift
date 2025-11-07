//
//  MainTabBarController.swift
//  VimeoSProject001
//
//  Created by Willy Hsu on 2025/11/7.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
    }

    private func configureTabs() {
        let home = MainHomeViewController()
        home.title = "首頁"

        let homeNav = UINavigationController(rootViewController: home)
        homeNav.tabBarItem = UITabBarItem(title: "首頁",
                                          image: UIImage(systemName: "house"),
                                          selectedImage: UIImage(systemName: "house.fill"))

        let verify = ViewController()
        verify.title = "Vimeo"

        let verifyNav = UINavigationController(rootViewController: verify)
        verifyNav.tabBarItem = UITabBarItem(title: "Vimeo",
                                            image: UIImage(systemName: "key"),
                                            selectedImage: UIImage(systemName: "key.fill"))

        viewControllers = [homeNav, verifyNav]
        selectedIndex = 0
    }
}
