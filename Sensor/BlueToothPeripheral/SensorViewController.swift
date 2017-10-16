//
//  SensorViewController.swift
//  BlueToothPeripheral
//
//  Created by Liqiang Ye on 10/13/2017.
//  Copyright © 2017 Liqiang Ye All rights reserved.
//

import UIKit

class SensorViewController: UIViewController, BLEPeripheralProtocol {
    
    
    func logToScreen(text: String) {
        print(text)
    }
    
    @IBOutlet weak var powerButton: UIButton!
    var ble: BLEPeripheralManager?
    
    @IBOutlet weak var sensorControllerView: UIView!
    
    
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        powerButton.setImage(UIImage(named: "on"), for: .selected)
        powerButton.setImage(UIImage(named: "off"), for: .normal)
        sensorControllerView.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Activate / disActivate the peripheral
    @IBAction func switchPeripheralOnOff(_ sender: Any) {
        
        //switch initial state is off/not selected
        
        if !self.powerButton.isSelected {
            self.powerButton.isSelected = !self.powerButton.isSelected
            print("starting peripheral")
            ble = BLEPeripheralManager()
            ble?.delegate = self
            ble!.startBLEPeripheral()
            sensorControllerView.isHidden = false
            bpmLabel.text = "\(ble?.heartRate ?? 85) bpm"
            tempLabel.text = "\(ble?.bodyTemperature ?? 97) ℉"
            pressureLabel.text = "\(ble?.systolic ?? 100)/\(ble?.diastolic ?? 70) mmHg"
            //logTextView.isHidden = false
        }
        else {
            self.powerButton.isSelected = !self.powerButton.isSelected
            sensorControllerView.isHidden = true
            //logTextView.isHidden = true
            print("stopping Peripheral")
            ble!.stopBLEPeripheral()
        }
        
    }
    
    @IBAction func onBPMminusButtonClicked(_ sender: Any) {
        ble?.heartRate -= 10
        bpmLabel.text = "\(ble?.heartRate ?? 70) bpm"
    }
    
    
    @IBAction func onBPMplusButtonClicked(_ sender: Any) {
        ble?.heartRate += 10
        bpmLabel.text = "\(ble?.heartRate ?? 70) bpm"
    }
    
    @IBAction func onTempminusButtonClicked(_ sender: Any) {
        ble?.bodyTemperature -= 1
        tempLabel.text = "\(ble?.bodyTemperature ?? 97) ℉"
    }
    
    @IBAction func onTempplusButtonClicked(_ sender: Any) {
        ble?.bodyTemperature += 1
        tempLabel.text = "\(ble?.bodyTemperature ?? 97) ℉"
    }
    
    @IBAction func onPressureminusButtonClicked(_ sender: Any) {
        ble?.systolic -= 10
        ble?.diastolic -= 5
        
        pressureLabel.text = "\(ble?.systolic ?? 120)/\(ble?.diastolic ?? 80) mmHg"
    }
    
    @IBAction func onPressureplusButtonClicked(_ sender: Any) {
        ble?.systolic += 10
        ble?.diastolic += 5
        
        pressureLabel.text = "\(ble?.systolic ?? 120)/\(ble?.diastolic ?? 80) mmHg"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
