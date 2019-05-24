//
//  DataManager.swift
//  BeaconCarLocation
//
//  Created by Mek on 03/03/18.
//  Copyright © 2018 Mek. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase
import Firebase

class DataManager
{
    static let shared = DataManager()
    
    var model: Model?
    
    var array: [String] = [""]
    
    
    
    var filePath: String!
    var storage: CLLocationCoordinate2D?
    var present: Int = 0
    
    func caricaDati()
    {
        filePath = cartellaDocuments() + "/coordi14.plist"
        
        if FileManager.default.fileExists(atPath: filePath) == true
        {
             array = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! Array
        }
        
    }
    
    func salva()
    {
        NSKeyedArchiver.archiveRootObject(array, toFile: filePath)
    }

    
    func cartellaDocuments() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
//    func beaconDataaas()
//    {
//        if let uid = Auth.auth().currentUser?.uid
//        {
//            let ref = Database.database().reference(fromURL: "https://beacon-car-location-1f96b.firebaseio.com")
//            ref.child("users").child(uid).child("beacons settings").observe(.value) { (snapshot) in
//                
//                self.model = Model(uuid: snapshot.childSnapshot(forPath: "uuid").value as! String, majorValue: snapshot.childSnapshot(forPath: "major value").value as! String, minorValue: snapshot.childSnapshot(forPath: "minor value").value as! String)
//                
//            }
//        }
//        
//        
//    }

}











