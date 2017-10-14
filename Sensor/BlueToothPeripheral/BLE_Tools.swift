//
//  BLE_Tools.swift
//  BlueToothPeripheral
//
//  Created by Olivier Robin on 06/03/2017.
//  Copyright © 2017 fr.ormaa. All rights reserved.
//

import Foundation
import CoreBluetooth

extension BLEPeripheralManager {
    
    func getState(peripheral: CBPeripheralManager) -> String {
        
        switch peripheral.state {
        case .poweredOn :
            return "poweredON"
        case .poweredOff :
            return "poweredOFF"
        case .resetting:
            return "resetting"
        case .unauthorized:
            return "unauthorized"
        case .unknown:
            return "unknown"
        case .unsupported:
            return "unsupported"
        }
    }

    
    
    

    func notifyValue() {
        delegate?.logToScreen(text: "Notifying health data to KP Health Monitor")
        
        // Set the data to notify
        let text = "Heartrate:\(heartRate) BodyTemperature:\(bodyTemperature) Systolic:\(systolic) Diastolic:\(diastolic)"
        let data: Data = text.data(using: String.Encoding.utf16)!
        
        delegate?.logToScreen(text: text)
        
        // update the value, which will generate a notification event on central side
        localPeripheralManager.updateValue(data, for: self.notifyCharac!, onSubscribedCentrals: [self.notifyCentral!])
        
    }
    
    
    
}
