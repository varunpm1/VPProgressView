//
//  VPBarProgressView.swift
//  VPProgressViewExample
//
//  Created by Varun P M on 17/08/16.
//  Copyright © 2016 VPM. All rights reserved.
//

import UIKit

private typealias VPPrivateFunctions = VPBarProgressView

class VPBarProgressView: VPProgressView {
    /// Bool that is used if rounded corned is needed or not. Defaults to true
    var needsRoundedEdges = true {
        didSet {
            if needsRoundedEdges {
                addRoundedCorner()
            }
        }
    }
    
    /// Used if `needsRoundedEdges` is set to `true`. Used for specifying the corner radius of progressView. Defaults to 5
    var roundedCornerWidth : CGFloat = 5 {
        didSet {
            if needsRoundedEdges {
                addRoundedCorner()
            }
        }
    }
    
    /// Defines the size needed for the `progressBarView`. Defaults to (150, 30). Centered horizontally center.
    var progressBarSize : CGSize = CGSizeMake(150, 30)
    
    // prgressView containerView
    private var progressContainerView : UIView!
    
    // progressView Instance
    private var progressView : UIView!
    
    // Width constraint to move the progressView
    private var progressViewWidthConstraint : NSLayoutConstraint!
    
    // Width constraint to set the progressContainerView
    private var progressViewContainerWidthConstraint : NSLayoutConstraint!
    
    // Height constraint to set the progressContainerView
    private var progressViewContainerHeightConstraint : NSLayoutConstraint!
    
    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initProgressView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initProgressView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set the progressViewColor and containerViewColor
        progressView.backgroundColor = progressColor
        progressContainerView.backgroundColor = progressContainerColor
        
        // Set the constraint values for progressBarSize
        progressViewContainerWidthConstraint.constant = progressBarSize.width
        progressViewContainerHeightConstraint.constant = progressBarSize.height
        
        // Set the frame for the label if needed.
        moveProgressLabel(byPercentage: percentageCompletion)
    }
    
    /// Helper function for moving the progressView with or without animation
    override func moveProgressView(percentage : CGFloat, animated : Bool) {
        super.moveProgressView(percentage, animated: animated)
        
        delegate?.willBeginProgress?()
        
        if animated {
            UIView.animateWithDuration(animationDuration, animations: {
                self.moveProgressViewWidth(byPercentage: percentage)
                self.layoutIfNeeded()
                }, completion: { (success) in
                    self.delegate?.didEndProgress?()
            })
        }
        else {
            moveProgressViewWidth(byPercentage: percentage)
            
            delegate?.didEndProgress?()
        }
    }
}

extension VPPrivateFunctions {
    //MARK: Private Helper functions
    // Add the progressView to the view
    private func initProgressView() {
        progressContainerView = UIView(frame: CGRectZero)
        progressContainerView.backgroundColor = progressContainerColor
        
        progressView = UIView(frame: CGRectZero)
        progressView.backgroundColor = progressColor
        
        addSubview(progressContainerView)
        progressContainerView.addSubview(progressView)
        
        addConstraintsForView(progressContainerView, parentView: self)
        addConstraintForProgressView()
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    // Add the necessary constraints for the progressView and containerView
    private func addConstraintsForView(view : UIView, parentView : UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: parentView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let centerXConstraint = NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: parentView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        
        progressViewContainerWidthConstraint = NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
        progressViewContainerHeightConstraint = NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
        
        parentView.addConstraints([topConstraint, centerXConstraint])
        view.addConstraints([progressViewContainerWidthConstraint, progressViewContainerHeightConstraint])
    }
    
    private func addConstraintForProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = NSLayoutConstraint(item: progressView, attribute: .Leading, relatedBy: .Equal, toItem: progressContainerView, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: progressView, attribute: .Top, relatedBy: .Equal, toItem: progressContainerView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: progressView, attribute: .Bottom, relatedBy: .Equal, toItem: progressContainerView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        
        progressViewWidthConstraint = NSLayoutConstraint(item: progressView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
        
        progressView.addConstraint(progressViewWidthConstraint)
        progressContainerView.addConstraints([leadingConstraint, topConstraint, bottomConstraint])
    }
    
    // Add the rounded corner radius if needed
    private func addRoundedCorner() {
        progressContainerView.layer.cornerRadius = roundedCornerWidth
        progressContainerView.layer.masksToBounds = true
        
        progressView.layer.cornerRadius = roundedCornerWidth
        progressView.layer.masksToBounds = true
    }
    
    // Change the widthConstraint to indicate the movement of progressView
    private func moveProgressViewWidth(byPercentage percentage : CGFloat) {
        // Convert the percentage to the needed width
        progressViewWidthConstraint.constant = (progressContainerView.bounds.size.width * percentage) / 100
        
        // Move the progress view by given percentage if needed
        moveProgressLabel(byPercentage: percentage)
    }
    
    private func moveProgressLabel(byPercentage percentage : CGFloat) {
        if let progressLabel = progressLabel {
            progressLabel.text = String(CGFloat(progressExtremeValues.minimum) + percentage * CGFloat(progressExtremeValues.maximum - progressExtremeValues.minimum) / 100)
            progressLabel.sizeToFit()
            
            // Calculate the frame of the label based on the updated size and place it so that it's center aligned with progress view endpoint
            progressLabel.center = CGPoint(x: CGRectGetMaxX(progressView.frame) + CGRectGetWidth(progressLabel.frame), y: CGRectGetMaxY(progressView.frame) + CGRectGetHeight(progressLabel.frame))
        }
    }
}