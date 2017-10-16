//
//  ViewController.swift
//  CentralManager
//
//  Created by Olivier Robin on 04/03/2017.
//  Copyright © 2017 fr.ormaa. All rights reserved.
//

import UIKit
import Pulsator
import PopupDialog

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
    
    
    
    @IBOutlet weak var bpmLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    
    
    var alertShown: Bool = false
    
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
        
        monitorView.isHidden = true
        
        let animation: CATransition = CATransition()
        animation.duration = 1.0
        animation.type = kCATransitionFade
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        bpmLabel.layer.add(animation, forKey: "changeTextTransition")
        
        
        initPulsators()

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
            
            self.hPulsator.start()
            self.tPulsator.start()
            self.pPulsator.start()
        }
    }
    
    func initPulsators() {
        
        self.connectionButton.layer.addSublayer(self.connectionPulsator)
        self.connectionButton.layoutIfNeeded()
        self.connectionPulsator.position = CGPoint(x: self.connectionButton.frame.width/2, y: self.connectionButton.frame.height/2)
        self.connectionPulsator.numPulse = 5
        self.connectionPulsator.radius = 85
        self.connectionPulsator.backgroundColor = UIColor.white.cgColor
        
        self.heartImageView.layer.addSublayer(self.hPulsator)
        self.heartImageView.layoutIfNeeded()
        self.hPulsator.position = CGPoint(x: self.heartImageView.frame.width/2, y: self.heartImageView.frame.height/2)
        self.hPulsator.numPulse = 3
        self.hPulsator.radius = 60.0
        self.hPulsator.backgroundColor = UIColor.white.cgColor
        
        
        self.tempImageView.layer.addSublayer(self.tPulsator)
        self.tempImageView.layoutIfNeeded()
        self.tPulsator.position = CGPoint(x: self.tempImageView.frame.width/2, y: self.tempImageView.frame.height/2)
        self.tPulsator.numPulse = 3
        self.tPulsator.radius = 60.0
        self.tPulsator.backgroundColor = UIColor.white.cgColor
        
        
        self.pressureImageView.layer.addSublayer(self.pPulsator)
        self.pressureImageView.layoutIfNeeded()
        self.pPulsator.position = CGPoint(x: self.pressureImageView.frame.width/2, y: self.pressureImageView.frame.height/2)
        self.pPulsator.numPulse = 3
        self.pPulsator.radius = 60.0
        self.pPulsator.backgroundColor = UIColor.white.cgColor
        
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
        
        let heartBeat = Int(messageArray[0]) ?? 70
        let temp = Int(messageArray[1]) ?? 97
        let systolic = Int(messageArray[2]) ?? 120
        let diastolic = Int(messageArray[3]) ?? 80
        
        if !self.hPulsator.isPulsating {
            self.hPulsator.start()
            self.tPulsator.start()
            self.pPulsator.start()
        }

        if heartBeat <= 100 && heartBeat >= 60 {
            self.hPulsator.backgroundColor = UIColor.green.cgColor
        } else {
            self.hPulsator.backgroundColor = UIColor.blue.cgColor
        }
        
        if temp < 100 && temp >= 96  {
            self.tPulsator.backgroundColor = UIColor.green.cgColor
        } else {
            self.tPulsator.backgroundColor = UIColor.blue.cgColor
        }
        
        if systolic <= 120 && systolic >= 80 && diastolic <= 80  && diastolic >= 60 {
            self.pPulsator.backgroundColor = UIColor.green.cgColor
        } else {
            self.pPulsator.backgroundColor = UIColor.blue.cgColor
        }
        
        if heartBeat > 120 && systolic < 80 && diastolic < 60 {
            if !alertShown{
              showHealthAlertDialog()
              alertShown = true
                
              self.appDelegate?.singleton.bluetoothController.write(uuid: self.characWrite, message: "We are connected...")

            }
        }
        
        self.bpmLabel.text = "\(heartBeat) bpm"
        self.tempLabel.text = "\(temp) ℉"
        self.pressureLabel.text = "\(systolic)/\(diastolic) mmHg"
        
    }
    
    func showHealthAlertDialog(animated: Bool = true) {
        
        // Prepare the popup assets
        let title = "KP Health Alert"
        let message = "We notice that your heart rate surges to a critical level and your blood pressure is dropping. \nAre you experiencing any of symptoms below?\n1. Chest pain or discomfort?\n2. Shortness of breath or anxiety?\n3. Pain in the jaw, neck, back or arms?\n4. Nausea and/or dizziness?\n5. Vomiting, indigestion or heartburn?\n6. Cold sweat?"
        let image = UIImage(named: "alert")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        
        let yesButton = DefaultButton(title: "Yes", height: 60, dismissOnTap: true) {
            self.performSegue(withIdentifier: "showActions", sender: nil)
        }
        
        let noButton = DefaultButton(title: "No", height: 60, dismissOnTap: true) {
            print("no")
        }
        
        // Add buttons to dialog
        popup.addButtons([yesButton, noButton])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }
    
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

