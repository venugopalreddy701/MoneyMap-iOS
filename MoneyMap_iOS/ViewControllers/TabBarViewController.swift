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
        super.viewDidLoad()
       //  Initialize View Controllers
               let vc1 = TransactionViewController()
               let vc2 = ProfileViewController()
       
       //  UINavigationView
               let nav1 = UINavigationController(rootViewController: vc1)
               let nav2 = UINavigationController(rootViewController: vc2)
       
        //  Setting Navbar tint colors according to System Mode
                nav1.navigationBar.tintColor = .label
                nav2.navigationBar.tintColor = .label
        
       
       //  UITabarItems
               nav1.tabBarItem = UITabBarItem(title: "Transactions", image: UIImage(systemName: "arrow.up.arrow.down.circle"), tag: 1)
               nav2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)
      
               
       // setViewControllers
               setViewControllers([nav1,nav2], animated: false)
    }
    
    
}
