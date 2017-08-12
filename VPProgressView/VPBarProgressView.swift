//
//  VPBarProgressView.swift
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
    var progressBarSize : CGSize = CGSize(width: 150, height: 30)
    
    // prgressView containerView
    fileprivate var progressContainerView : UIView!
    
    // progressView Instance
    fileprivate var progressView : UIView!
    
    // Width constraint to move the progressView
    fileprivate var progressViewWidthConstraint : NSLayoutConstraint!
    
    // Width constraint to set the progressContainerView
    fileprivate var progressViewContainerWidthConstraint : NSLayoutConstraint!
    
    // Height constraint to set the progressContainerView
    fileprivate var progressViewContainerHeightConstraint : NSLayoutConstraint!
    
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
    override func moveProgressView(_ percentage : CGFloat, animated : Bool) {
        super.moveProgressView(percentage, animated: animated)
        
        delegate?.willBeginProgress?()
        
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
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
    fileprivate func initProgressView() {
        progressContainerView = UIView(frame: CGRect.zero)
        progressContainerView.backgroundColor = progressContainerColor
        
        progressView = UIView(frame: CGRect.zero)
        progressView.backgroundColor = progressColor
        
        addSubview(progressContainerView)
        progressContainerView.addSubview(progressView)
        
        addConstraintsForView(progressContainerView, parentView: self)
        addConstraintForProgressView()
        
        self.backgroundColor = UIColor.clear
    }
    
    // Add the necessary constraints for the progressView and containerView
    fileprivate func addConstraintsForView(_ view : UIView, parentView : UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let centerXConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: parentView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        progressViewContainerWidthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        progressViewContainerHeightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        
        parentView.addConstraints([topConstraint, centerXConstraint])
        view.addConstraints([progressViewContainerWidthConstraint, progressViewContainerHeightConstraint])
    }
    
    fileprivate func addConstraintForProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = NSLayoutConstraint(item: progressView, attribute: .leading, relatedBy: .equal, toItem: progressContainerView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: progressView, attribute: .top, relatedBy: .equal, toItem: progressContainerView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: progressView, attribute: .bottom, relatedBy: .equal, toItem: progressContainerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        progressViewWidthConstraint = NSLayoutConstraint(item: progressView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
        
        progressView.addConstraint(progressViewWidthConstraint)
        progressContainerView.addConstraints([leadingConstraint, topConstraint, bottomConstraint])
    }
    
    // Add the rounded corner radius if needed
    fileprivate func addRoundedCorner() {
        progressContainerView.layer.cornerRadius = roundedCornerWidth
        progressContainerView.layer.masksToBounds = true
        
        progressView.layer.cornerRadius = roundedCornerWidth
        progressView.layer.masksToBounds = true
    }
    
    // Change the widthConstraint to indicate the movement of progressView
    fileprivate func moveProgressViewWidth(byPercentage percentage : CGFloat) {
        // Convert the percentage to the needed width
        progressViewWidthConstraint.constant = (progressContainerView.bounds.size.width * percentage) / 100
        
        // Move the progress view by given percentage if needed
        moveProgressLabel(byPercentage: percentage)
    }
    
    fileprivate func moveProgressLabel(byPercentage percentage : CGFloat) {
        if let progressLabel = progressLabel {
            progressLabel.text = String(describing: CGFloat(progressExtremeValues.minimum) + percentage * CGFloat(progressExtremeValues.maximum - progressExtremeValues.minimum) / 100)
            progressLabel.sizeToFit()
            
            // Calculate the frame of the label based on the updated size and place it so that it's center aligned with progress view endpoint
            progressLabel.center = CGPoint(x: progressView.frame.maxX + progressLabel.frame.width, y: progressView.frame.maxY + progressLabel.frame.height)
        }
    }
}
