//
//  VPProgressView.swift
//  VPProgressViewExample
//
//  Created by Varun P M on 01/08/16.
//  Copyright © 2016 VPM. All rights reserved.
//

import UIKit

@objc protocol VPProgressViewProtocol : class {
    /// Called when progressView is about to begin animation
    optional func willBeginProgress()
    
    /// Called when progressView has completed the animation
    optional func didEndProgress()
}

class VPProgressView: UIView {
    /// Defines the color for progressView. Defaults to whiteColor.
    var progressContainerColor : UIColor = UIColor.whiteColor()
    
    /// Defines the color for progressView. Defaults to blackColor.
    var progressColor : UIColor = UIColor.blackColor()
    
    /// Defines the duration for animation. This will not have effect if in moveProgressView(_:, _:) animated is set to false. Defaults to 0.5
    var animationDuration = 0.5
    
    /// Delegate for handling progressView animation
    weak var delegate : VPProgressViewProtocol?
    
    /// Denotes the percentage completion of the progressView (0-100 percent)
    var percentageCompletion : CGFloat = 0
    
    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Public functions
    /// Sets the progressView by the given percentage. The percentage should be in between 0 and 100. If not, nothing will happen.
    final func setProgressViewCompletion(withPercentageCompletion percentage : CGFloat, animated : Bool) {
        if isTargetPercentageValueInRange(forPercentage: percentage, isAdding: false) {
            moveProgressView(percentage, animated: animated)
        }
    }
    
    /// Move the progressView by the given percentage. Unlike the `setProgressViewCompletion(withPercentageCompletion percentage : CGFloat, animated : Bool)`, this moves by given percentage, whereas the former method sets the progress given percentage. The `byPercentage` should be such that
    ///
    /// 0 <= (`percentageCompletion` + `byPercentage`) <= 100
    final func moveProgressView(byPercentageCompletion byPercentage : CGFloat, animated : Bool) {
        if isTargetPercentageValueInRange(forPercentage: byPercentage, isAdding: true) {
            moveProgressView(byPercentage + percentageCompletion, animated: animated)
        }
    }
    
    //MARK: Private functions
    // Check if the target percentage of progressView is within valid range
    private func isTargetPercentageValueInRange(forPercentage percentage : CGFloat, isAdding : Bool) -> Bool {
        var targetPercentage : CGFloat = 0
        
        if isAdding {
            targetPercentage = percentageCompletion + percentage
        }
        else {
            targetPercentage = percentage
        }
        
        return (targetPercentage >= 0 && targetPercentage <= 100)
    }
}

//MARK: Overridable functions to be overridden only by subclasses. Do not call this method directly unless subclassed.
extension VPProgressView {
    /// Overrided public functions
    func moveProgressView(percentage : CGFloat, animated : Bool) {
        // Update the percentage completion
        percentageCompletion = percentage
    }
}