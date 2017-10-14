//
//  SensorViewController.swift
//  BlueToothPeripheral
//
//  Created by Liqiang Ye on 10/13/17.
//  Copyright © 2017 fr.ormaa. All rights reserved.
//

import UIKit

class SensorViewController: UIViewController, BLEPeripheralProtocol{
    
    @IBOutlet weak var logTextView: UITextView!
    
    func logToScreen(text: String) {
        print(text)
        var str = logTextView.text + "\n"
        str += text
        logTextView.text = str
        logTextView.setContentOffset(CGPoint.zero, animated: false)
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
        logTextView.isHidden = true
        logTextView.setContentOffset(CGPoint.zero, animated: false)

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
            bpmLabel.text = "\(ble?.heartRate ?? 70) bpm"
            tempLabel.text = "\(ble?.bodyTemperature ?? 97) ℉"
            pressureLabel.text = "\(ble?.systolic ?? 120)/\(ble?.diastolic ?? 80) mmHg"
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
        ble?.heartRate -= 1
        bpmLabel.text = "\(ble?.heartRate ?? 70) bpm"
    }
    
    
    @IBAction func onBPMplusButtonClicked(_ sender: Any) {
        ble?.heartRate += 1
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
        ble?.systolic -= 5
        ble?.diastolic -= 5
        
        pressureLabel.text = "\(ble?.systolic ?? 120)/\(ble?.diastolic ?? 80) mmHg"
    }
    
    @IBAction func onPressureplusButtonClicked(_ sender: Any) {
        ble?.systolic += 5
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
