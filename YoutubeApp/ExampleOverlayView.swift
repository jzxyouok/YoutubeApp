//
//  ExampleOverlayView.swift
//  KolodaView
//
//  Created by Eugene Andreyev on 6/21/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//
//

import UIKit
import Koloda

private let overlayRightImageName = "overlay_like"
private let overlayLeftImageName = "overlay_skip"

//test

class ExampleOverlayView: OverlayView {
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        
        return imageView
        }()
    
    @IBOutlet lazy var extraOverlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        
        return imageView
        }()
    
    var leadingConstraint: NSLayoutConstraint?
    var trailingConstraint: NSLayoutConstraint?
    
    override var overlayState:SwipeResultDirection?  {
        didSet {
            switch overlayState! {
            case .Left :
                if leadingConstraint == nil {
                    leadingConstraint = extraOverlayImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
                }
                leadingConstraint!.isActive = false
                if trailingConstraint == nil {
                    trailingConstraint = self.trailingAnchor.constraint(equalTo: extraOverlayImageView.trailingAnchor, constant: 20)
                }
                trailingConstraint!.isActive = true
                extraOverlayImageView.image = UIImage(named: overlayLeftImageName)
            case .Right :
                if trailingConstraint == nil {
                    trailingConstraint = self.trailingAnchor.constraint(equalTo: extraOverlayImageView.trailingAnchor, constant: 20)
                }
                trailingConstraint!.isActive = false
                if leadingConstraint == nil {
                    leadingConstraint = extraOverlayImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
                }
                leadingConstraint!.isActive = true
                extraOverlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                extraOverlayImageView.image = nil
            }
            
        }
    }
    
}
