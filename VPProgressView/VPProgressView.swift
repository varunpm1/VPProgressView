//
//  VPProgressView.swift
//  VPProgressViewExample
//
//  Created by Varun on 01/08/16.
//  Copyright © 2016 VPM. All rights reserved.
//

import UIKit

private typealias VPPrivateFunctions = VPProgressView

class VPProgressView: UIView {
    
    /// Defines the duration for animation. This will not have effect if in moveProgressView(_:, _:) animated is set to false. Defaults to 0.5
    var animationDuration = 0.5
    
    // progressView Instance
    private var progressView : UIView!
    
    // Width constraint to move the progressView
    private var progressViewWidthConstraint : NSLayoutConstraint!
    
    // Denotes the percentage completion of the progressView
    private var percentageCompletion : CGFloat = 0
    
    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initProgressView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initProgressView()
    }
    
    //MARK: Public functions
    /// Sets the progressView by the given percentage. The percentage should be in between 0 and 100. If not, nothing will happen.
    func setProgressViewCompletion(withPercentageCompletion percentage : CGFloat, animated : Bool) {
        if isTargetPercentageValueInRange(forPercentage: percentage, isAdding: false) {
            if animated {
                UIView.animateWithDuration(animationDuration, animations: {
                    self.moveProgressViewWidth(byPercentage: percentage)
                    self.layoutIfNeeded()
                })
            }
            else {
                moveProgressViewWidth(byPercentage: percentage)
            }
        }
    }
    
    /// Move the progressView by the given percentage. Unlike the `moveProgressView(withPercentageCompletion percentage : CGFloat, animated : Bool)`, this moves by given percentage, whereas the former method sets the progress given percentage. The `byPercentage` should be such that the
    ///
    /// 0 <= (`percentageCompletion` + `byPercentage`) <= 100
    func moveProgressView(byPercentageCompletion byPercentage : CGFloat, animated : Bool) {
        if isTargetPercentageValueInRange(forPercentage: byPercentage, isAdding: true) {
            if animated {
                UIView.animateWithDuration(animationDuration, animations: {
                    self.moveProgressViewWidth(byPercentage: byPercentage + self.percentageCompletion)
                    self.layoutIfNeeded()
                })
            }
            else {
                moveProgressViewWidth(byPercentage: byPercentage + percentageCompletion)
            }
        }
    }
}

private extension VPPrivateFunctions {
    //MARK: Private Helper functions
    // Add the progressView to the view
    private func initProgressView() {
        progressView = UIView(frame: CGRectZero)
        progressView.backgroundColor = UIColor.blackColor()
        
        self.addSubview(progressView)
        
        addConstraintsForProgressView()
    }
    
    // Add the necessary constraints for the progressView
    private func addConstraintsForProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = NSLayoutConstraint(item: progressView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: progressView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: progressView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        
        progressViewWidthConstraint = NSLayoutConstraint(item: progressView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
        progressView.addConstraint(progressViewWidthConstraint)
        
        self.addConstraints([leadingConstraint, topConstraint, bottomConstraint])
    }
    
    // Change the widthConstraint to indicate the movement of progressView
    private func moveProgressViewWidth(byPercentage percentage : CGFloat) {
        // Convert the percentage to the needed width
        progressViewWidthConstraint.constant = (self.bounds.size.width * percentage) / 100
    }
    
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