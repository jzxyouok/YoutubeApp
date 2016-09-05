//
//  LoadingViewController.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 05/09/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView
import StatefulViewController

class LoadingView: BasicPlaceholderView, StatefulPlaceholderView, NVActivityIndicatorViewable {
    
    override func setupView() {
        super.setupView()
        
        self.backgroundColor = UIColor(red: CGFloat(237 / 255.0), green: CGFloat(85 / 255.0), blue: CGFloat(101 / 255.0), alpha: 1)
        
        let cols = 4
        let rows = 8
        let cellWidth = Int(self.frame.width / CGFloat(cols))
        let cellHeight = Int(self.frame.height / CGFloat(rows))
        
        (NVActivityIndicatorType.BallPulse.rawValue ... NVActivityIndicatorType.LineScaleParty.rawValue).forEach {
            let x = ($0 - 1) % cols * cellWidth
            let y = ($0 - 1) / cols * cellHeight
            let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
            let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                type: NVActivityIndicatorType(rawValue: $0)!)
            let animationTypeLabel = UILabel(frame: frame)
            
            animationTypeLabel.text = String($0)
            animationTypeLabel.sizeToFit()
            animationTypeLabel.textColor = UIColor.whiteColor()
            animationTypeLabel.frame.origin.x += 5
            animationTypeLabel.frame.origin.y += CGFloat(cellHeight) - animationTypeLabel.frame.size.height
            
            activityIndicatorView.padding = 20
            if ($0 == NVActivityIndicatorType.SemiCircleSpin.rawValue) {
                activityIndicatorView.padding = 0
            }
            
            self.addSubview(activityIndicatorView)
            self.addSubview(animationTypeLabel)
            activityIndicatorView.startAnimation()
            
            let button:UIButton = UIButton(frame: frame)
            button.tag = $0
            button.addTarget(self,
                action: #selector(buttonTapped(_:)),
                forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(button)
        }
    }
    
    func buttonTapped(sender: UIButton) {
        let size = CGSize(width: 30, height:30)
        
        //startActivityAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: sender.tag)!)
        
        let activityContainer: UIView = UIView(frame: UIScreen.mainScreen().bounds)
        
        activityContainer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        activityContainer.restorationIdentifier = "NVActivityIndicatorViewContainer"
        
        let actualSize = size ?? CGSizeMake(60, 60)
        let activityIndicatorView = NVActivityIndicatorView(
            frame: CGRectMake(0, 0, actualSize.width, actualSize.height),
            type: NVActivityIndicatorType(rawValue: sender.tag)!,
            color: UIColor.redColor(),
            padding: 10)
        
        activityIndicatorView.center = activityContainer.center
        activityIndicatorView.startAnimation()
        activityContainer.addSubview(activityIndicatorView)
        
        let width = activityContainer.frame.size.width / 3
        let message="Loading..."
        if message == "Loading..." {
            let label = UILabel(frame: CGRectMake(0, 0, width, 30))
            label.center = CGPointMake(
                activityIndicatorView.center.x,
                activityIndicatorView.center.y + actualSize.height)
            label.textAlignment = .Center
            label.text = message
            label.font = UIFont.boldSystemFontOfSize(20)
            label.textColor = activityIndicatorView.color
            activityContainer.addSubview(label)
        }
        
        UIApplication.sharedApplication().keyWindow!.addSubview(activityContainer)
        performSelector(#selector(delayedStopActivity),
                        withObject: nil,
                        afterDelay: 2.5)
    }
    
    func delayedStopActivity() {
        //stopActivityAnimating()
    }
    
}
