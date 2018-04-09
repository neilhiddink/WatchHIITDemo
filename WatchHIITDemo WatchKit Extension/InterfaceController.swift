//
//  InterfaceController.swift
//  WatchHIITDemo WatchKit Extension
//
//  Created by Neil Hiddink on 4/9/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var elapsedLabel: WKInterfaceLabel!
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var workoutTimer: WKInterfaceTimer!
    @IBOutlet var intervalTimer: WKInterfaceTimer!
    @IBOutlet var startStopButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    
    override func willActivate() {
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
    }

    @IBAction func startStopButtonPressed() {
        
    }
}
