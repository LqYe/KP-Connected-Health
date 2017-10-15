//
//  ViewController.swift
//  CentralManager
//
//  Created by Olivier Robin on 04/03/2017.
//  Copyright © 2017 fr.ormaa. All rights reserved.
//

import UIKit
import Pulsator

class ViewController: UIViewController, BLEProtocol {
    
//    @IBOutlet weak var bleLogTextView: UITextView!
    
    var connectionPulsator = Pulsator()
    var hPulsator = Pulsator()
    var tPulsator = Pulsator()
    var pPulsator = Pulsator()

    

    var appDelegate:AppDelegate? = nil
    
    @IBOutlet weak var connectionButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var connectionButton: UIButton!
    
    @IBOutlet weak var connectionStatusLabel: UILabel!
    
    
    
    @IBOutlet weak var heartImageView: UIImageView!
    
    @IBOutlet weak var tempImageView: UIImageView!
    
    @IBOutlet weak var pressureImageView: UIImageView!
    
    
    @IBOutlet weak var monitorView: UIView!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    
    @IBOutlet weak var bpmLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    // this is the name of the peripheral that we are looking for.
    // change it as you want. but change it also on peripheral side.
    // note : if you want to connect using the main service of the peripheral : this peripheral need to advertise its service, in advertise area
    //
    //let peripheralName = "ORMAA_P1.0"
    let peripheralUUID = "00001901-0000-1000-8000-00805F9B34FB"
    let characRead = "2AC6A7BF-2C60-42D0-8013-AECEF2A124C0" //"00002B00-0000-1000-8000-00805F9B34FB"
    let characWrite = "9B89E762-226A-4BBB-A381-A4B8CC6E1105"
    
    
    var timerRead: Timer? = nil
    var timerWrite: Timer? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate =  UIApplication.shared.delegate as! AppDelegate?
        appDelegate!.singleton.logger.log("viewDidLoad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        appDelegate!.singleton.logger.log("viewDidAppear")
        
//        bleLogTextView.text = ""
    
        if appDelegate!.singleton.appRestored {
            appDelegate!.singleton.bluetoothController.restoreCentralManager(viewControllerDelegate: self,
                                                                             centralName: appDelegate!.singleton.centralManagerToRestore)
        }
        
        monitorView.isHidden = true
        warningLabel.isHidden = true
    }
    
    func log(_ object: Any?) {
        appDelegate?.singleton.logger.log(object)
    }
    
    // Add text to the UITextView
    func addText(text: String) {
        log(text)
        
        DispatchQueue.main.async {
//            let txt = self.bleLogTextView.text + "\n"
//            self.bleLogTextView.text = txt + text
            self.connectionStatusLabel.text = text
        }
    }
    
    
    // user clicked on start central button
    @IBAction func startCentralClick(_ sender: Any) {
        log("start central click")
        
        //RH Healthness gives much better implementation of bluetooth pattern
        //the code here is messy
        
        self.connectionButton.layer.addSublayer(self.connectionPulsator)
        self.connectionButton.layoutIfNeeded()
//        self.connectionPulsator.anchorPoint = CGPoint(x: self.connectionButton.center.x, y: self.connectionButton.center.y)

        self.connectionPulsator.position = CGPoint(x: self.connectionButton.frame.width/2, y: self.connectionButton.frame.height/2)
        self.connectionPulsator.numPulse = 5
        self.connectionPulsator.radius = 120.0
        self.connectionPulsator.backgroundColor = UIColor.white.cgColor
        self.connectionPulsator.start()
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {

            
            self.addText(text: "Trying to Pair KP Health Sensor")
            if !self.appDelegate!.singleton.bluetoothController.startCentralManager(viewControllerDelegate: self) {
                // Display en error
                self.addText(text: "Pairing Error: Bluetooth is off...")
                return
            }
            
            self.addText(text: "Searching for KP Health Sensor...")
            
            if !self.appDelegate!.singleton.bluetoothController.searchDevice(uuidName: self.peripheralUUID) {
                // Display en error
//                self.addText(text: "KP Health Sensor was not found, even after a while. check its name, and if it is near, and swithed on.\n please try again later.")
                self.addText(text: "KP Health Sensor was not found...please try again later.")

                return
            }
            
//            self.addText(text: "KP Health Sensor : " + self.peripheralUUID + " discovered.")
            self.addText(text: "Discovered KP Health Sensor")

            if !self.appDelegate!.singleton.bluetoothController.connectToDevice(uuid: self.peripheralUUID) {
                // Display en error
                self.addText(text: "Connection failed !!!")
                return
            }
            
            self.addText(text: "Connected to KP Health Sensor")
            
            if !self.appDelegate!.singleton.bluetoothController.discoverServices() {
                self.addText(text: "Discover service and characteristics failed !!!")
                return
            }
            
            self.addText(text: "Start monitoring your health...")
            
//            self.addText(text: "request notification for charac :\n" + self.characRead)
//            self.appDelegate!.singleton.bluetoothController.requestNotify(uuid: self.characRead)
//            self.addText(text: "notify done" + self.characRead)

//            self.addText(text: "Read a value, from peripheral :\n" + self.characRead)
//            self.appDelegate?.singleton.bluetoothController.read(uuid: self.characRead)
//
//            self.appDelegate?.singleton.bluetoothController.write(uuid: self.characWrite, message: "We are connected...")
//            self.addText(text: "write requested : " + self.characWrite)
            
            self.afterConnectionSuccess()
            
            
            // start some timer, which will read or write data from / to peripheral
            //self.timerRead = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(self.read), userInfo: nil, repeats: true)
            //self.timerWrite = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(self.write), userInfo: nil, repeats: true)
            
        }
    }
    
    func afterConnectionSuccess() {
    
        DispatchQueue.main.async {
            self.connectionPulsator.stop()
            self.connectionButtonHeight.constant = 0
            self.connectionStatusLabel.text = "Connected to KP Health Sensor"
            self.monitorView.isHidden = false
            
        }
    }
    
    func read() {
        self.addText(text: "Read value returned by peripheral : " + self.characRead)

        self.appDelegate?.singleton.bluetoothController.read(uuid: characRead)
        
    }
    
    
    
    // called by bluetooth stack
    //
    func valueRead(message: String) {
        //self.addText(text: "Read : " + message)
        let messageArray = message.components(separatedBy: ",")
        
        self.bpmLabel.text = "\(messageArray[0]) bpm"
        self.tempLabel.text = "\(messageArray[1]) ℉"
        self.pressureLabel.text = "\(messageArray[2])/\(messageArray[3]) mmHg"    }
    
    func valueWrite(message: String) {
        self.addText(text: "write : " + message)
    }
    
    
    
    
    // disconnected : ble is too far away, or sitched off
    func disconnected(message: String) {
        
    }
    
    
    
    // connection to ble failed
    func failConnected(message: String) {
    }
    
    
    
    func connected(message: String) {
    }
    

    
}

