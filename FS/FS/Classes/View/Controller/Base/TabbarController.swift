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
        tabBar.tintColor = UIColor(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)

        let homeController = HomeViewController()
        homeController.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "ic_home"), selectedImage: #imageLiteral(resourceName: "ic_home_selected"))
        let homeNavigation = UINavigationController(rootViewController: homeController)
        
        let searchController = SearchViewController()
        searchController.tabBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "ic_search"), selectedImage: #imageLiteral(resourceName: "ic_search_selected"))
        let searchNavigation = UINavigationController(rootViewController: searchController)

        let favoriteController = FavoriteViewController()
        favoriteController.tabBarItem = UITabBarItem(title: "Favorite", image: #imageLiteral(resourceName: "ic_favorite"), selectedImage: #imageLiteral(resourceName: "ic_favorite_selected"))
        let favoriteNavigation = UINavigationController(rootViewController: favoriteController)

        let profileController = ProfileViewController()
        profileController.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "ic_profile"), selectedImage: #imageLiteral(resourceName: "ic_profile_selected"))
        let profileNavigation = UINavigationController(rootViewController: profileController)

        viewControllers = [homeNavigation, searchNavigation, favoriteNavigation, profileNavigation]
    }
}
