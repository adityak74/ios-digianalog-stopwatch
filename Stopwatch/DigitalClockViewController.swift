//
//  DigitalClockViewController.swift
//  Stopwatch
//
//  Created by Aditya Karnam Gururaj Rao on 11/19/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

class DigitalClockViewController: UIViewController, NotificationProtocol {

    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var millisecondsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDefaults()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func formatTimeIntervalToString(_ time: TimeInterval) -> (minutes: String, seconds: String, milliseconds: String) {
        let minutes = (Int(time) / 60) % 60
        let seconds = Int(time) % 60
        let milliSeconds = Int(time * 100) % 100
        return (String(format: "%02d", minutes), String(format: "%02d", seconds), String(format: "%02d", milliSeconds))
    }
    
    func lapUpdated(with timestamp: TimeInterval) {
        
    }
    
    func timerUpdated(to timeStamp: TimeInterval) {
        let value = formatTimeIntervalToString(timeStamp)
        minutesLabel.text = value.minutes
        secondsLabel.text = value.seconds
        millisecondsLabel.text = value.milliseconds
    }
    
    func resetViewToDefault() {
        setupDefaults()
    }
    
    func setupDefaults() {
        minutesLabel.text = "00"
        secondsLabel.text = "00"
        millisecondsLabel.text = "00"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
