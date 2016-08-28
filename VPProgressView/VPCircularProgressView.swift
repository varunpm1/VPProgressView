//
//  VPCircularProgressView.swift
//  VPProgressViewExample
//
//  Created by Varun P M on 17/08/16.
//  Copyright © 2016 VPM. All rights reserved.
//

import UIKit

class VPCircularProgressView: VPProgressView {
    
    enum Direction : Int {
        case ClockWise
        case AntiClockWise
    }
    
    /// Defines the radius needed for the progressView. Defaults to the view's bounds
    var progressViewRadius : CGFloat = 100
    
    /// Defines the direction for the progressView. Defaults to clockWise
    var progressViewDirection = Direction.ClockWise
    
    // Variables for creating the progressView shape layer
    private var bezierPath = UIBezierPath()
    private let shapeLayer = CAShapeLayer()
    
    // Variable for tracking if animation is needed or not
    private var isAnimationNeeded = true
    
    // Current completed progress in percentage
    private var currentCompletionPercentage : CGFloat = 0
    
    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initProgressViewLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initProgressViewLayer()
    }
    
    // Draw the layer with/without animation
    override func drawRect(rect: CGRect) {
        // Create our arc, with the correct angles
        bezierPath.addArcWithCenter(getMidPointForFrame(rect), radius: progressViewRadius, startAngle: getAngleInRadiansForPercentageCompletion(currentCompletionPercentage), endAngle: getAngleInRadiansForPercentageCompletion(percentageCompletion), clockwise: (progressViewDirection == .ClockWise))
        
        shapeLayer.path = bezierPath.CGPath
        shapeLayer.strokeColor = progressColor.CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.lineWidth = 5
        
        // Animate the transition if needed
        if isAnimationNeeded {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = animationDuration
            animation.fromValue = currentCompletionPercentage / 100
            animation.toValue = 1
            animation.removedOnCompletion = true
            animation.delegate = self
            
            shapeLayer.addAnimation(animation, forKey: "strokeEndAnimation")
        }
        
        currentCompletionPercentage = percentageCompletion
    }
    
    // Init the layer for progressView layer
    private func initProgressViewLayer() {
        self.layer.addSublayer(shapeLayer)
    }
    
    //MARK: Calculations helper functions
    private func getMidPointForFrame(frame : CGRect) -> CGPoint {
        return CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    }
    
    private func getAngleInRadiansForPercentageCompletion(percentage : CGFloat) -> CGFloat {
        let piValue = CGFloat(M_PI)
        let finalPercentageValue = (progressViewDirection == .ClockWise) ? percentage : (100 - percentage)
        
        return (((2 * piValue) * finalPercentageValue / 100) - piValue)
    }
    
    /// Overridable functions
    /// Move the progressView to a percentage with/without animation
    override func moveProgressView(percentage: CGFloat, animated: Bool) {
        super.moveProgressView(percentage, animated: animated)
        
        delegate?.willBeginProgress?()
        
        isAnimationNeeded = animated
        self.setNeedsDisplay()
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            delegate?.didEndProgress?()
        }
    }
}
