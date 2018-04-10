//
//  InterfaceController.swift
//  WatchHIITDemo WatchKit Extension
//
//  Created by Neil Hiddink on 4/9/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import WatchKit
import Foundation

// MARK: InterfaceController: WKInterfaceController

class InterfaceController: WKInterfaceController {

    // MARK: Properties
    
    let myInterval: TimeInterval = 15.0
    
    private var isStarted: Bool = false
    private var isRunning: Bool = true
    private var timer = Timer()
    
    private var statusString = "Stopped"
    private var workoutTime: TimeInterval = 0.0
    private var intervalTime: TimeInterval = 0.0
    
    // MARK: IB Outlets
    
    @IBOutlet var elapsedLabel: WKInterfaceLabel!
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var workoutTimer: WKInterfaceTimer!
    @IBOutlet var intervalTimer: WKInterfaceTimer!
    @IBOutlet var startStopButton: WKInterfaceButton!
    
    // MARK: Life Cycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        intervalTime = myInterval
    }
    
    override func willActivate() {
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
    }
    
    // MARK: Helper Methods
    
    private func resetWKTimer(timer: WKInterfaceTimer, interval: TimeInterval) {
        // NOTE: values > 0 for interval --> countdown | values <= 0 for interval --> stopwatch
        timer.stop()
        let time = Date(timeIntervalSinceNow: interval)
        timer.setDate(time)
        timer.start()
    }
    
    // Format seconds into strings of hh:mm:ss
    func formatTimeInterval(timeInterval: TimeInterval) -> String {
        let secondsInHour = 3600
        let secondsInMinute = 60
        var time = Int(timeInterval)
        let hours = time / secondsInHour
        time = time % secondsInHour
        let minutes = time / secondsInMinute
        let seconds = time % secondsInMinute
        return String(format:"%02i:%02i:%02i",hours,minutes,seconds)
    }
    
    // MARK: Timers
    
    // Simple Timer Object
    func loopTimer1(interval: TimeInterval) {
        if timer.isValid {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: interval,
                                                   target: self,
                                                   selector: #selector(loopTimer1DidEnd(timer:)),
                                                   userInfo: nil,
                                                   repeats: false)
        resetWKTimer(timer: intervalTimer, interval: interval)
        resetWKTimer(timer: workoutTimer, interval: 0)
    }
    
    // Repeating Timer Object
    func loopTimer2(interval: TimeInterval) {
        if timer.isValid {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(loopTimer2DidEnd(timer:)),
                                     userInfo: interval,
                                     repeats: true)
        resetWKTimer(timer: intervalTimer, interval: interval)
        resetWKTimer(timer: workoutTimer, interval: 0)
    }
    
    // Repeating Timer Object without WKInterfaceTimer
    func loopTimer3(interval: TimeInterval, timerInterval: TimeInterval) {
        if timer.isValid {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: timerInterval,
                                     target: self,
                                     selector: #selector(loopTimer3DidEnd(timer:)),
                                     userInfo: interval,
                                     repeats: true)
        resetWKTimer(timer: intervalTimer, interval: interval)
        resetWKTimer(timer: workoutTimer, interval: 0)
    }
    
    @objc func loopTimer1DidEnd(timer: Timer) {
        statusLabel.setText("Stopped")
        startStopButton.setTitle("Start")
        isStarted = false
        intervalTimer.stop()
        workoutTimer.stop()
        timer.invalidate()
    }
    
    @objc func loopTimer2DidEnd(timer: Timer) {
        isRunning != isRunning
        resetWKTimer(timer: intervalTimer, interval: timer.userInfo as! TimeInterval)
        if isRunning {
            statusLabel.setText("Run")
        } else {
            statusLabel.setText("Walk")
        }
    }
    
    @objc func loopTimer3DidEnd(timer: Timer) {
        // infinite loop with events in the selector
        // uses labels instead of witch kit timers
        workoutTime += timer.timeInterval  // increment count up timers
        intervalTime -= timer.timeInterval // decrement count down timers
        if intervalTime <= 0 { // the workout interval is over
            // switch activities
            intervalTime = timer.userInfo as! TimeInterval
            isRunning = !isRunning
            resetWKTimer(timer: intervalTimer, interval: timer.userInfo as! TimeInterval)
            if isRunning {
                statusString = "Run "
            } else {
                statusString = "Walk "
            }
        }
        statusLabel.setText(statusString + formatTimeInterval(timeInterval: intervalTime))
        elapsedLabel.setText(formatTimeInterval(timeInterval: workoutTime))
    }
    
    // MARK: IB Actions

    @IBAction func startStopButtonPressed() {
        isStarted = !isStarted // toggle bool value
        if !isStarted {
            // statusLabel.setText("Run")
            if isRunning {
                statusLabel.setText("Run")
                statusString = "Run "
            } else {
                statusLabel.setText("Walk")
                statusString = "Walk "
            }
            startStopButton.setTitle("Stop")
            
            // loopTimer1(interval: myInterval)
            // loopTimer2(interval: myInterval)
            loopTimer3(interval: myInterval, timerInterval: 0.25)
        } else {
            startStopButton.setTitle("Start")
            workoutTimer.stop()
            intervalTimer.stop()
            timer.invalidate()
        }
    }
}
