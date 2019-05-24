//
//  Firebase.swift
//  BeaconCarLocation
//
//  Created by Mek on 04/05/18.
//  Copyright © 2018 Mek. All rights reserved.
//

import UIKit
import Firebase

class Firebase: NSObject
{
    
    class func uidUser() -> String
    {
        guard let uid = Auth.auth().currentUser?.uid else { return "empty" }
        return uid
    }
    
    class func coordinate() -> DatabaseReference
    {
        let uid = uidUser()
        let ref = Database.database().reference(fromURL: "https://beacon-car-location-1f96b.firebaseio.com")
        let usersReferences = ref.child("users").child(uid).child("beacons settings").child("coordinate")
        return usersReferences
    }
    
    class func logOut()
    {
        do
        {
            try Auth.auth().signOut()
        }
        catch let logoutError { debugPrint(logoutError) }
    }
    
    class func beaconSettings() -> DatabaseReference
    {
        let uid = uidUser()
        let ref = Database.database().reference(fromURL: "https://beacon-car-location-1f96b.firebaseio.com")
        let usersReferences = ref.child("users").child(uid).child("beacons settings")
        return usersReferences
    }
    
    
    
    

}
