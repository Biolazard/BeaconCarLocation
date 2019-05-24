//
//  ViewController.swift
//  BeaconCarLocation
//
//  Created by Mek on 03/03/18.
//  Copyright © 2018 Mek. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(handleLogout))
        navigationItem.title = "Info"

    }

    @objc func handleBeaconSettings()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleLogout()
    {
        do
        {
            try Auth.auth().signOut()
        }
        catch let logoutError { debugPrint(logoutError) }
        self.navigationController?.pushViewController(BeaconSetup(), animated: false)
    }
    
    
   

}

