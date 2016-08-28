//
//  MainViewController.swift
//  VPProgressViewExample
//
//  Created by Varun P M on 01/08/16.
//  Copyright © 2016 VPM. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var progressView: VPBarProgressView!
    @IBOutlet weak var circularProgressView: VPCircularProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.progressView.delegate = self
        self.progressView.progressColor = UIColor.redColor()
        self.progressView.animationDuration = 0.7
        self.progressView.needsRoundedEdges = true
        self.progressView.roundedCornerWidth = 7
        self.progressView.progressBarSize = CGSize(width: 200, height: 30)
        self.progressView.progressLabelFont = UIFont.systemFontOfSize(15)
        self.progressView.progressValues = (100, 200)
        
        for i in 0.stride(to: 10, by: 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((1 + Double(i)) * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                self.progressView.moveProgressView(byPercentageCompletion: 10, animated: true)
            }
        }
        
        self.circularProgressView.progressColor = UIColor.greenColor()
        self.circularProgressView.progressContainerColor = UIColor.redColor()
        self.circularProgressView.animationDuration = 0.5
        
        for i in 0.stride(to: 10, by: 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((1 + Double(i)) * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                self.circularProgressView.moveProgressView(byPercentageCompletion: 10, animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainViewController : VPProgressViewProtocol {
    func willBeginProgress() {
        print("Animation will begin")
    }
    
    func didEndProgress() {
        print("Animation ended")
    }
}