//
//  SettingController.swift
//  BeaconCarLocation
//
//  Created by Mek on 04/04/18.
//  Copyright © 2018 Mek. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI
import Firebase

class SettingController: UITableViewController, MFMailComposeViewControllerDelegate
{
    
    override func viewDidLoad()
    {
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("IMPOSTAZIONI", comment: "")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        cell.selectionStyle = UITableViewCellSelectionStyle.default
        
        switch indexPath.section
        {
        case 0:
            cell.textLabel?.text = "Beacon"
            
        case 1:
            cell.textLabel?.text = NSLocalizedString("SUR", comment: "")
            
        case 2:
            cell.textLabel?.text = NSLocalizedString("EMAILS", comment: "")
            
        default:
            cell.textLabel?.text = "Logout"
            
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        switch section
        {
        case 0:
            return NSLocalizedString("UMM", comment: "")
        case 1:
            return NSLocalizedString("SURSUB", comment: "")
        case 2:
            return NSLocalizedString("EMAILSUB", comment: "")
        default:
            return ""
        }
    }
    
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section
        {
        case 0:
            DataManager.shared.present = 1
            show(BeaconSetup(), sender: nil)
 
        case 1:
            SKStoreReviewController.requestReview()
            
        case 2:
            if MFMailComposeViewController.canSendMail()
            {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["mekstyle96@gmail.com"])
                mail.setSubject("Beacon Car Location")
                present(mail, animated: true)
            }
            else
            {
                return
            }
            
        default:
            Firebase.logOut()
            self.navigationController?.pushViewController(BeaconSetup(), animated: false)
            
            
            
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true)
    }
    
    
    

}















