//
//  TabBarViewController.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 03/04/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transactionVC = TransactionViewController()
        let profileVC = ProfileViewController()

        let transactionNav = UINavigationController(rootViewController: transactionVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        transactionNav.navigationBar.tintColor = .label
        profileNav.navigationBar.tintColor = .label
        
        transactionNav.tabBarItem = UITabBarItem(
            title: "Transactions",
            image: UIImage(systemName: "arrow.up.arrow.down.circle"),
            tag: 1
        )
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            tag: 2
        )
        
        setViewControllers([transactionNav, profileNav], animated: false)
    }
}

