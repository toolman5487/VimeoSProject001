//
//  MainTabBarController.swift
//  VimeoSProject001
//
//  Created by Willy Hsu on 2025/11/7.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private enum Tab: Int, CaseIterable {
        case home
        case my

        var title: String {
            switch self {
            case .home: return "Home"
            case .my: return "Person"
            }
        }

        var icon: String {
            switch self {
            case .home: return "house"
            case .my: return "person"
            }
        }

        var selectedIcon: String {
            switch self {
            case .home: return "house.fill"
            case .my: return "person.fill"
            }
        }

        func makeRootController() -> UIViewController {
            switch self {
            case .home:
                let vc = MainHomeViewController()
                vc.title = title
                return vc
            case .my:
                let vc = MainMeViewController()
                vc.title = "Me"
                return vc
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureTabs()
    }

    private func configureTabs() {
        viewControllers = Tab.allCases.map { tab in
            let controller = tab.makeRootController()
            let navigation = UINavigationController(rootViewController: controller)
            navigation.tabBarItem = UITabBarItem(title: tab.title,
                                                 image: UIImage(systemName: tab.icon),
                                                 selectedImage: UIImage(systemName: tab.selectedIcon))
            return navigation
        }
        selectedIndex = Tab.home.rawValue
    }

    private func configureAppearance() {
        tabBar.tintColor = .label
        tabBar.unselectedItemTintColor = .secondaryLabel
    }
}
