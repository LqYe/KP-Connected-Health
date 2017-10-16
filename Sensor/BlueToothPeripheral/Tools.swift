//
//  StringExtension.swift
//  BlueToothCentral
//
//  Created by Liqiang Ye on 10/13/2017.
//  Copyright © 2017 Liqiang Ye All rights reserved.
//

import Foundation
import UserNotifications

class Tools {
    
    static func toString(_ txt: String?) -> String {
        if (txt == nil) {
            return "???"
        }
        else {
            return txt!
        }
    }
    
    
    static func sendNotification(name: String, objectName: String?, object: AnyObject?) {
        
        let user: [String:AnyObject]  = [objectName! : object!]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: name),
                                        object: nil, userInfo: user)
    }
    
}
