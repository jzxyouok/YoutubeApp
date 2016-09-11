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
        
        self.backgroundColor = UIColor.lightGrayColor()
        
        let cols = 3
        let rows = 8
        let cellWidth = Int(self.frame.width / CGFloat(cols))
        let cellHeight = Int(self.frame.height / CGFloat(rows))
        
        let loader = NVActivityIndicatorType.LineScale.rawValue
        let x = 1 * cellWidth
        let y = 2 * cellHeight
        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                            type: NVActivityIndicatorType(rawValue: loader)!)
        let animationTypeLabel = UILabel(frame: frame)
        animationTypeLabel.text = "Please wait while your videos are loading."
        animationTypeLabel.sizeToFit()
        animationTypeLabel.numberOfLines=0
        animationTypeLabel.textColor = UIColor.whiteColor()
        animationTypeLabel.frame.origin.x = (self.frame.width-animationTypeLabel.frame.width)/2
        animationTypeLabel.frame.origin.y += CGFloat(cellHeight)
        
        activityIndicatorView.padding = 20
        if (loader == NVActivityIndicatorType.SemiCircleSpin.rawValue) {
            activityIndicatorView.padding = 0
        }
        
        self.addSubview(activityIndicatorView)
        self.addSubview(animationTypeLabel)
        activityIndicatorView.startAnimation()
        
        let button:UIButton = UIButton(frame: frame)
        button.tag = loader
        button.addTarget(self,
                         action: #selector(buttonTapped(_:)),
                         forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(button)
        
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
        for item in self.subviews
            where item.restorationIdentifier == "NVActivityIndicatorViewContainer" {
                item.removeFromSuperview()
        }
    }
    
}
