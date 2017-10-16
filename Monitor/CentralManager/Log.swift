//
//  Log.swift
//  CentralManager
//
//  Created by Liqiang Ye on 10/13/2017.
//  Copyright © 2017 Liqiang Ye All rights reserved.
//

import Foundation


class Log {

    let shared = UserDefaults(suiteName: "group.Liqiang Yecentral.log")
    var logStr = ""
    
    // Delete log file
    func deleteLog() {
        shared?.removeObject(forKey: "group.Liqiang Yecentral.log")
    }
    
    // save log to nsUserDefault.
    // This allow to use another app, with same group, in order to read what heppen
    // when this app is in background for example !
    //
    func saveLog(value: String) {
        shared?.setValue(value + "\n", forKey: "group.Liqiang Yecentral.log")
    }

    // log an object
    //
    func log(_ text: Any?) {
        
        if text == nil {
            
        }
        else {
            let str = getDate() + " - " + String(describing: text! as Any)
            print(str)

            logStr += str + "\n"
            saveLog(value: logStr)
        }
    }
    
    // Format date, with milli seconds, and local time
    //
    func getDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .short
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.dateFormat = "y-MM-dd -- H:m:ss.SSSS"
        let dateStr = formatter.string(from: date)
        return dateStr
    }
    
    
}
