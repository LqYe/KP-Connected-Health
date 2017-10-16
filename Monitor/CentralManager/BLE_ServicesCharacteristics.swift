//
//  BLECentralManager+ServicesCharacteristics.swift
//  BlueToothCentral
//
//  Created by Liqiang Ye on 10/13/2017.
//  Copyright © 2017 Liqiang Ye All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit
import UserNotifications



extension BLECentralManager {
    
    
    // allow the discover services and characteristics of the peripharal already connected
    //
    func discoverServicesAndCharac() {
        bleError = ""
        servicesDiscovered.removeAll()
        
        //calls delegate method below to load all services from peripheral
        peripheralConnected?.discoverServices( nil )

    }


    
    func setNotify(characteristicUUID: String) {

//        peripheralConnected?.services?.forEach({ (oneService) in
//            oneService.characteristics?.forEach({ (oneCharacteristic) in
//                if oneCharacteristic.uuid == CBUUID(string: characteristicUUID) {
//                    peripheralConnected?.setNotifyValue(true, for: oneCharacteristic)
//                    log("request notification done")
//                }
//            })
//        })
        
    }
    
    
    
    
    // delegate
    // Discovered service of the peripheral
    //
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if error != nil {
            bleError = ("Error discovering services: \(error!.localizedDescription)")
            log(bleError)
        }
        else {
            log("didDiscoverServices services")
        }
        
        peripheral.services?.forEach({ (oneService) in
            log("------ Service : " + Tools.toString( oneService.uuid.uuidString ))
            // discopver the characteristics for that service
            peripheral.discoverCharacteristics(nil, for: oneService)
        })
    }
    
    
    
    // delegate
    // discovered characteristics for a service
    //
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
        if error != nil {
            bleError = ("Error service characteristics: \(error!.localizedDescription)")
            log(bleError)
        }
        else {
            log("didDiscoverCharacteristicsFor")
        }
        
        if !servicesDiscovered.contains(service) {
            servicesDiscovered.append(service)
        }

        // enumerate all the characteristics of this service
        service.characteristics?.forEach({ (oneCharacteristic) in
            log("-- Characteristic : " + Tools.toString( oneCharacteristic.uuid.uuidString ))
        })
        
        for characteristics  in service.characteristics! {
            if characteristics.uuid.uuidString == "2AC6A7BF-2C60-42D0-8013-AECEF2A124C0" {
                peripheral.setNotifyValue(true, for: characteristics)
            }
        }
        
        isServicesDiscovered = true
        
    }
    
    
    
    // delegate
    // tell if notification when we request a notification for a charac.
    //
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            bleError = ("Error didUpdateNotificationStateFor : " + error!.localizedDescription)
        }
        else {
            log("didUpdateNotificationStateFor characteristic : " + characteristic.uuid.uuidString )
        }
    }
    

    

    
}
