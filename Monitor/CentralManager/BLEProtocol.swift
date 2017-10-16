//
//  BLEProtocol.swift
//  CentralManager
//
//  Created by Liqiang Ye on 10/13/2017.
//  Copyright © 2017 Liqiang Ye All rights reserved.
//

import Foundation


protocol BLEProtocol {
    
    func disconnected(message: String)
    func failConnected(message: String)
    func connected(message: String)
    func valueRead(message: String)
    func valueWrite(message: String)

}
