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
    
    // progressView Instance
    private var progressView : UIView!
    
    // Width constraint to move the progressView
    private var progressViewWidthConstraint : NSLayoutConstraint!
    
    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initProgressView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initProgressView()
    }
    
    override func setProgressViewColor() {
        if let _ = progressView {
            progressView.backgroundColor = progressColor
        }
    }
    
    /// Change the widthConstraint to indicate the movement of progressView
    override func moveProgressViewWidth(byPercentage percentage : CGFloat) {
        // Convert the percentage to the needed width
        progressViewWidthConstraint.constant = (self.bounds.size.width * percentage) / 100
    }
    
    /// Helper function for moving the progressView with or without animation
    override func moveProgressView(percentage : CGFloat, animated : Bool) {
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
        progressView = UIView(frame: CGRectZero)
        progressView.backgroundColor = progressColor
        
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
    
    // Add the rounded corner radius if needed
    private func addRoundedCorner() {
        self.layer.cornerRadius = roundedCornerWidth
        self.layer.masksToBounds = true
    }
}