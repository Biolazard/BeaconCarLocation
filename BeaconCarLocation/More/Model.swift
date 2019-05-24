//
//  Model.swift
//  BeaconCarLocation
//
//  Created by Mek on 05/03/18.
//  Copyright © 2018 Mek. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class Model: NSObject
{
    var uuid: String
    var majorValue: String
    var minorValue: String
    
    init(uuid: String, majorValue: String, minorValue: String)
    {
        self.uuid = uuid
        self.majorValue = majorValue
        self.minorValue = minorValue
    }
    

}
