//
//  HomeTabBarController.swift
//  On The Map
//
//  Created by Javon Davis on 25/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

extension HomeTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let sectionNavigationController = viewController as? UINavigationController {
            if let viewController = sectionNavigationController.viewControllers[0] as? StudentMapViewController {
                viewController.switchingTabs = true
            }
            
            if let viewController = sectionNavigationController.viewControllers[0] as? StudentListTableViewController {
                viewController.switchingTabs = true
            }
        }
        return true
    }
}
