//
//  TabBarController.swift
//  BeaconCarLocation
//
//  Created by Mek on 08/03/18.
//  Copyright © 2018 Mek. All rights reserved.
//

import UIKit
import Firebase


class TabBarController: UITabBarController
{
    static let shared = TabBarController()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewControllers = [createTab(viewController: Mappa(), name: NSLocalizedString("MAPPA", comment: ""), image: #imageLiteral(resourceName: "ping")), createTab(viewController: SettingController(), name: NSLocalizedString("IMPOSTAZIONI", comment: ""), image: #imageLiteral(resourceName: "settings"))]
        

    }

    private func createTab(viewController: UIViewController, name: String, image: UIImage) -> UINavigationController
    {
        let viewController = viewController
        let beaconSetupTab = UINavigationController(rootViewController: viewController)
        beaconSetupTab.tabBarItem.title = name
        beaconSetupTab.tabBarItem.image = image
        return beaconSetupTab
    }

    

    
}








