//
//  VPCircularProgressView.swift
//  VPProgressViewExample
//
//  Created by Varun P M on 17/08/16.
//  Copyright © 2016 VPM. All rights reserved.
//

import UIKit

class VPCircularProgressView: VPProgressView {
    
    /// Defines the radius needed for the progressView. Defaults to the view's bounds
    var progressViewRadius : CGFloat = 100
    
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
        bezierPath.addArcWithCenter(CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), radius: progressViewRadius, startAngle: (2 * CGFloat(M_PI)) * currentCompletionPercentage / 100, endAngle: (2 * CGFloat(M_PI)) * percentageCompletion / 100, clockwise: false)
        
        shapeLayer.path = bezierPath.CGPath
        shapeLayer.strokeColor = progressColor.CGColor
        shapeLayer.fillColor = progressContainerColor.CGColor
        shapeLayer.lineWidth = 5
        
        if isAnimationNeeded {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = animationDuration
            animation.fromValue = currentCompletionPercentage / 100
            animation.toValue = percentageCompletion / 100
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
    
    /// Overridable functions
    /// Move the progressView to a percentage with/without animation
    override func moveProgressView(percentage: CGFloat, animated: Bool) {
        super.moveProgressView(percentage, animated: animated)
        
        delegate?.willBeginProgress?()
        
        isAnimationNeeded = animated
        self.setNeedsLayout()
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            delegate?.didEndProgress?()
        }
    }
}
