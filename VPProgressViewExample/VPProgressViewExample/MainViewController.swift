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
        self.progressView.progressColor = UIColor.red
        self.progressView.animationDuration = 0.7
        self.progressView.needsRoundedEdges = true
        self.progressView.roundedCornerWidth = 7
        self.progressView.progressBarSize = CGSize(width: 200, height: 30)
        self.progressView.progressLabelFont = UIFont.systemFont(ofSize: 15)
        self.progressView.progressExtremeValues = (100, 200)
        
        for i in stride(from: 0, to: 10, by: 1) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64((1 + Double(i)) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                self.progressView.moveProgressView(byPercentageCompletion: 10, animated: true)
            }
        }
        
        self.circularProgressView.progressColor = UIColor.green
        self.circularProgressView.progressContainerColor = UIColor.red
        self.circularProgressView.animationDuration = 0.5
        self.circularProgressView.progressExtremeValues = (50, 60)
        self.circularProgressView.progressLabelFont = UIFont.systemFont(ofSize: 15)
        
        for i in stride(from: 0, to: 10, by: 1) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64((1 + Double(i)) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
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
