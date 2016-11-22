//
//  AnalogClockView.swift
//  Stopwatch
//
//  Created by Aditya Karnam Gururaj Rao on 11/20/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

class AnalogClockView: UIView {
    private(set) var analogClockLayer : AnalogClockLayer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        if analogClockLayer == nil {
            analogClockLayer = AnalogClockLayer()
            layer.addSublayer(analogClockLayer!)
        }
        analogClockLayer?.frame = rect
        analogClockLayer?.setNeedsDisplay()
        
    }
    
    func updateTimerText(timerText: String) {
        analogClockLayer?.changeTimerText(timerText: timerText)
    }
    
    func updateLap(seconds: Int) {
        var transform: CGAffineTransform
        transform = CGAffineTransform(rotationAngle: CGFloat(Double(seconds) * M_PI) / 30.0)
        analogClockLayer?.addLapArrow()
        analogClockLayer?.rotateLapArrow(with: transform)
    }
    
    func startDial(seconds: Int){
        var transform: CGAffineTransform
        transform = CGAffineTransform(rotationAngle: CGFloat(Double(seconds) * M_PI) / 30.0)
        //transform = CGAffineTransform(rotationAngle: CGFloat(Double(milliseconds) * 0.01))
        analogClockLayer?.rotateArrow(with: transform)
    }
    
    func resetDial() {
        analogClockLayer?.resetDialToOriginal()
        analogClockLayer?.removeLapArrowLayer()
        analogClockLayer?.changeTimerText(timerText: "00:00.00")
    }

}
