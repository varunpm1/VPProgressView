//
//  VPCircularProgressView.swift
//  Version 0.0.1
//
//  Created by Varun P M on 17/08/16.
//  Copyright © 2016 VPM. All rights reserved.
//

//  MIT License
//
//  Copyright (c) 2016 Varun P M
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class VPCircularProgressView: VPProgressView, CAAnimationDelegate {
    
    enum Direction : Int {
        case clockWise
        case antiClockWise
    }
    
    /// Defines the radius needed for the progressView. Defaults to the view's bounds
    var progressViewRadius : CGFloat = 100
    
    /// Defines the direction for the progressView. Defaults to clockWise
    var progressViewDirection = Direction.clockWise
    
    /// Defines the progressView line stroke width. Defaults to 5
    var progressViewLineWidth : CGFloat = 5
    
    // Variables for creating the progressView shape layer
    fileprivate var bezierPath = UIBezierPath()
    fileprivate let shapeLayer = CAShapeLayer()
    
    // Variable for tracking if animation is needed or not
    fileprivate var isAnimationNeeded = true
    
    // Current completed progress in percentage
    fileprivate var currentCompletionPercentage : CGFloat = 0
    
    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initProgressViewLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initProgressViewLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        alignProgressDisplayLabel()
    }
    
    // Draw the layer with/without animation
    override func draw(_ rect: CGRect) {
        // Create our arc, with the correct angles
        bezierPath.addArc(withCenter: getMidPointForFrame(rect), radius: progressViewRadius, startAngle: getAngleInRadiansForPercentageCompletion(currentCompletionPercentage), endAngle: getAngleInRadiansForPercentageCompletion(percentageCompletion), clockwise: (progressViewDirection == .clockWise))
        
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = progressColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = progressViewLineWidth
        
        // Animate the transition if needed
        if isAnimationNeeded {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = animationDuration
            animation.fromValue = currentCompletionPercentage / percentageCompletion // Calculate the start point for the animation using the previously set progress completion value
            animation.toValue = 1
            animation.isRemovedOnCompletion = true
            animation.delegate = self
            
            shapeLayer.add(animation, forKey: "strokeEndAnimation")
        }
        
        currentCompletionPercentage = percentageCompletion
        
        // Update the percentage completion
        updateProgressData(currentCompletionPercentage)
    }
    
    // Init the layer for progressView layer
    fileprivate func initProgressViewLayer() {
        self.layer.addSublayer(shapeLayer)
    }
    
    //MARK: Calculations helper functions
    fileprivate func getMidPointForFrame(_ frame : CGRect) -> CGPoint {
        return CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    }
    
    fileprivate func getAngleInRadiansForPercentageCompletion(_ percentage : CGFloat) -> CGFloat {
        let piValue = CGFloat(Double.pi)
        let finalPercentageValue = (progressViewDirection == .clockWise) ? percentage : (100 - percentage)
        
        return (((2 * piValue) * finalPercentageValue / 100) - piValue)
    }
    
    //TODO: UILabel placing customization
    // Place the UILabel at the center of the view
    fileprivate func alignProgressDisplayLabel() {
        progressLabel?.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
    
    //TODO: UILabel text change animations
    // Update the UILabel text placed in center
    fileprivate func updateProgressData(_ percentage : CGFloat) {
        guard let progressLabel = progressLabel else { return }
        
        progressLabel.text = String(describing: CGFloat(progressExtremeValues.minimum) + percentage * CGFloat(progressExtremeValues.maximum - progressExtremeValues.minimum) / 100)
        progressLabel.sizeToFit()
    }
    
    /// Overridable functions
    /// Move the progressView to a percentage with/without animation
    override func moveProgressView(_ percentage: CGFloat, animated: Bool) {
        super.moveProgressView(percentage, animated: animated)
        
        delegate?.willBeginProgress?()
        
        isAnimationNeeded = animated
        self.setNeedsDisplay()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            delegate?.didEndProgress?()
        }
    }
}
