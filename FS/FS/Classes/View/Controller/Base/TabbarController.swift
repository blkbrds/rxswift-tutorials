//
//  TabbarController.swift
//  FS
//
//  Created by at-thinhuv on 11/30/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import UIKit
import SwiftUtils

class TabbarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        tabBar.tintColor = UIColor.RGB(50, 194, 77)

        let homeController = HomeViewController()
        let homeNavigation = UINavigationController(rootViewController: homeController)
        let searchController = SearchViewController()
        let searchNavigation = UINavigationController(rootViewController: searchController)

        // Favorite view controller
        let favoriteController = FavoriteViewController()
        let favoriteTabbarItem = UITabBarItem(title: "Favorite", image: #imageLiteral(resourceName: "favorite"), selectedImage: #imageLiteral(resourceName: "favoriteSelected"))
        favoriteController.tabBarItem = favoriteTabbarItem
        let favoriteNavigation = UINavigationController(rootViewController: favoriteController)

        let profileController = ProfileViewController()
        let profileNavigation = UINavigationController(rootViewController: profileController)

        viewControllers = [homeNavigation, searchNavigation, favoriteNavigation, profileNavigation]
    }
}
