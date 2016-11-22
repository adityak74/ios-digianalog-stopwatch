//
//  AnalogClockLayer.swift
//  Stopwatch
//
//  Created by Aditya Karnam Gururaj Rao on 11/20/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

class AnalogClockLayer: CALayer {
    
    private var arrowLayer = CALayer()
    private var lapArrowLayer = CALayer()
    private var dialImage = CALayer()
    var timerTextLayer = CATextLayer()
    
    override func draw(in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        
        dialImage.bounds = bounds
        dialImage.position = CGPoint(x: bounds.midX, y: bounds.midY)
        dialImage.contents = #imageLiteral(resourceName: "stopwatch_dark").cgImage
        
        addSublayer(dialImage)
        
        
        //Cardinal Points
        let points = ["60", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]
        
        for index in 0..<points.count {
            let textLayer = CATextLayer()
            textLayer.string = points[index]
            textLayer.fontSize = 25.0
            textLayer.bounds = CGRect(x: 0, y: -12, width: 50, height: 50)
            textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
            let vertex: CGFloat = dialImage.bounds.midY / textLayer.bounds.height
            textLayer.anchorPoint = CGPoint(x: 0.5, y: vertex)
            textLayer.alignmentMode = kCAAlignmentCenter
            textLayer.foregroundColor = UIColor.white.cgColor
            textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(Double(index) * M_PI / 6.0)))
            
            dialImage.addSublayer(textLayer)
        }
        
        //TimerString
        timerTextLayer.string = "00:00.00"
        timerTextLayer.bounds = CGRect(x: 0, y: 0, width: 150, height: 40)
        timerTextLayer.position = CGPoint(x: bounds.midX , y: bounds.midY + bounds.height/1.5 )
        let vertex: CGFloat = dialImage.bounds.midY / timerTextLayer.bounds.height
        timerTextLayer.anchorPoint = CGPoint(x: 0.5, y: vertex)
        timerTextLayer.alignmentMode = kCAAlignmentCenter
        dialImage.addSublayer(timerTextLayer)
        
        // Lap Arrow
        lapArrowLayer.bounds = bounds
        lapArrowLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        lapArrowLayer.anchorPoint = CGPoint(x: 0.5, y: 0.45)
        lapArrowLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(0 * M_PI / 2)))
        lapArrowLayer.contents = arrowImage(color: UIColor.blue)?.cgImage
        addSublayer(lapArrowLayer)
        lapArrowLayer.isHidden = true
        
        //Arrow
        arrowLayer.bounds = bounds
        arrowLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        arrowLayer.anchorPoint = CGPoint(x: 0.5, y: 0.45)
        arrowLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(0 * M_PI / 2)))
        arrowLayer.contents = arrowImage(color: UIColor.orange)?.cgImage
        
        addSublayer(arrowLayer)
        
        UIGraphicsPopContext()
        
    }
    
    func arrowImage(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width : frame.width, height : frame.height), false, 1.0)
        
        if let ctx = UIGraphicsGetCurrentContext() {
            
            
            ctx.move(to: CGPoint(x : frame.width / 2, y: 0))
            ctx.addLine(to: CGPoint(x: frame.width/2, y: frame.height/2))
            ctx.setLineWidth(2)
            ctx.setStrokeColor(color.cgColor)
            ctx.strokePath()
            
            let arrowImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return arrowImage
            
        }
        return nil
        
    }
    
    func addLapArrow()  {
        lapArrowLayer.isHidden = false
    }
    func removeLapArrowLayer()  {
        lapArrowLayer.isHidden = true
        lapArrowLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(0 * M_PI) / 2.0))
    }
    
    func rotateLapArrow(with transform: CGAffineTransform) {
        CATransaction.setAnimationDuration(1)
        lapArrowLayer.setAffineTransform(transform)
    }
    
    func changeTimerText(timerText: String)  {
        timerTextLayer.string = timerText
    }
    
    func rotateArrow(with transform: CGAffineTransform) {
        CATransaction.setAnimationDuration(1)
        arrowLayer.setAffineTransform(transform)
    }
    
    func resetDialToOriginal() {
        CATransaction.setAnimationDuration(1.0)
        arrowLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(0 * M_PI) / 2.0))
    }

}
