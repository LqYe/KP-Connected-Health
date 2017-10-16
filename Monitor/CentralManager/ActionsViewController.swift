//
//  ActionsViewController.swift
//  CentralManager
//
//  Created by Liqiang Ye on 10/15/17.
//  Copyright © 2017 fr.ormaa. All rights reserved.
//

import UIKit
import PopupDialog

class ActionsViewController: UIViewController {

    @IBOutlet weak var emergencyLineImage: UIImageView!
    @IBOutlet weak var mapImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emergencyLineImage.isUserInteractionEnabled = true
        mapImageView.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDismissNavButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func onTappingEmergencyLine(_ sender: Any) {
        
        showCallDialog()
        
    }
    
    func showCallDialog(animated: Bool = true) {
        
        // Prepare the popup
        let title = "Call KP Emergency Line"
        let message = "Call (925)-100-1000 ?"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
            print("Completed")
        }
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL") {
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "OK") {
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }
    
    
    @IBAction func onTappingDirection(_ sender: Any) {
        showDirectionDialog()
    }
    
    
    func showDirectionDialog(animated: Bool = true) {
        
        // Prepare the popup
        let title = "Get Direction to Closest KP Medical Center"
        let message = "Based on your location, the closest KP medical center is the newly built Dublin center at 3200 Dublin Blvd, Dublin, CA 94568"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
            print("Completed")
        }
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL") {
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "GO") {
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
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
