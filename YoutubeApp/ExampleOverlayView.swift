//
//  ExampleOverlayView.swift
//  KolodaView
//
//  Created by Eugene Andreyev on 6/21/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
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
    
    override var overlayState:OverlayMode  {
        didSet {
            switch overlayState {
            case .Left :
                if leadingConstraint == nil {
                    leadingConstraint = extraOverlayImageView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 20)
                }
                leadingConstraint!.active = false
                if trailingConstraint == nil {
                    trailingConstraint = self.trailingAnchor.constraintEqualToAnchor(extraOverlayImageView.trailingAnchor, constant: 20)
                }
                trailingConstraint!.active = true
                extraOverlayImageView.image = UIImage(named: overlayLeftImageName)
            case .Right :
                if trailingConstraint == nil {
                    trailingConstraint = self.trailingAnchor.constraintEqualToAnchor(extraOverlayImageView.trailingAnchor, constant: 20)
                }
                trailingConstraint!.active = false
                if leadingConstraint == nil {
                    leadingConstraint = extraOverlayImageView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 20)
                }
                leadingConstraint!.active = true
                extraOverlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                extraOverlayImageView.image = nil
            }
            
        }
    }
    
}
