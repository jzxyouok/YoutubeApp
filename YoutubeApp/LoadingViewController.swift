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
        
        self.backgroundColor = UIColor.lightGray
        
        let cols = 3
        let rows = 8
        let cellWidth = Int(self.frame.width / CGFloat(cols))
        let cellHeight = Int(self.frame.height / CGFloat(rows))
        
        let loader = NVActivityIndicatorType.lineScale.rawValue
        let x = 1 * cellWidth
        let y = 2 * cellHeight
        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                            type: NVActivityIndicatorType(rawValue: loader)!)
        let animationTypeLabel = UILabel(frame: frame)
        animationTypeLabel.text = NSLocalizedString("Please wait while your videos are loading.", comment: "")
        animationTypeLabel.sizeToFit()
        animationTypeLabel.numberOfLines=0
        animationTypeLabel.textColor = UIColor.white
        animationTypeLabel.frame.origin.x = (self.frame.width-animationTypeLabel.frame.width)/2
        animationTypeLabel.frame.origin.y += CGFloat(cellHeight)
        
        activityIndicatorView.padding = 20
        if (loader == NVActivityIndicatorType.semiCircleSpin.rawValue) {
            activityIndicatorView.padding = 0
        }
        
        self.addSubview(activityIndicatorView)
        self.addSubview(animationTypeLabel)
        activityIndicatorView.startAnimating()
        
        let button:UIButton = UIButton(frame: frame)
        button.tag = loader
        button.addTarget(self,
                         action: #selector(buttonTapped(_:)),
                         for: UIControlEvents.touchUpInside)
        self.addSubview(button)
        
    }
    
    func buttonTapped(_ sender: UIButton) {
        let size = CGSize(width: 30, height:30)
        
        //startActivityAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: sender.tag)!)
        
        let activityContainer: UIView = UIView(frame: UIScreen.main.bounds)
        
        activityContainer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        activityContainer.restorationIdentifier = "NVActivityIndicatorViewContainer"
        
        let actualSize = size ?? CGSize(width: 60, height: 60)
        let activityIndicatorView = NVActivityIndicatorView(
            frame: CGRect(x: 0, y: 0, width: actualSize.width, height: actualSize.height),
            type: NVActivityIndicatorType(rawValue: sender.tag)!,
            color: UIColor.red,
            padding: 10)
        
        activityIndicatorView.center = activityContainer.center
        activityIndicatorView.startAnimating()
        activityContainer.addSubview(activityIndicatorView)
        
        let width = activityContainer.frame.size.width / 3
        let message="Loading..."
        if message == "Loading..." {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 30))
            label.center = CGPoint(
                x: activityIndicatorView.center.x,
                y: activityIndicatorView.center.y + actualSize.height)
            label.textAlignment = .center
            label.text = message
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textColor = activityIndicatorView.color
            activityContainer.addSubview(label)
        }
        
        UIApplication.shared.keyWindow!.addSubview(activityContainer)
        perform(#selector(delayedStopActivity),
                        with: nil,
                        afterDelay: 2.5)
    }
    
    func delayedStopActivity() {
        for item in self.subviews
            where item.restorationIdentifier == "NVActivityIndicatorViewContainer" {
                item.removeFromSuperview()
        }
    }
    
}
