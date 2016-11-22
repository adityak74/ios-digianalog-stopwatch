//
//  AnalogClockViewController.swift
//  Stopwatch
//
//  Created by Aditya Karnam Gururaj Rao on 11/19/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

class AnalogClockViewController: UIViewController, NotificationProtocol {

    @IBOutlet weak var analogClockView: AnalogClockView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    fileprivate func formatTimeIntervalToString(_ time: TimeInterval) -> (minutes: String, seconds: String, milliseconds: String) {
        let minutes = (Int(time) / 60) % 60
        let seconds = Int(time) % 60
        let milliSeconds = Int(time * 100) % 100
        return (String(format: "%02d", minutes), String(format: "%02d", seconds), String(format: "%02d", milliSeconds))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func lapUpdated(with timestamp: TimeInterval) {
        let value = formatTimeIntervalToString(timestamp)
        analogClockView.updateLap(seconds: Int(value.seconds)!)
    }
    
    func timerUpdated(to timeStamp: TimeInterval) {
        let value = formatTimeIntervalToString(timeStamp)
        analogClockView.startDial(seconds: Int(value.seconds)!)
        analogClockView.updateTimerText(timerText: value.minutes + ":" + value.seconds + "." + value.milliseconds)
    }
    
    func resetViewToDefault() {
        analogClockView.resetDial()
    }
}
