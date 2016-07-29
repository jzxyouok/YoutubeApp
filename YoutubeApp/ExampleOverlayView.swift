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

protocol OverlayViewDelegate{
    func myVCDidFinish(controller:OverlayView, image: UIImage)
}

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
    
    override var overlayState:OverlayMode  {
        didSet {
            switch overlayState {
            case .Left :
                extraOverlayImageView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 50).active = false
                self.trailingAnchor.constraintEqualToAnchor(extraOverlayImageView.trailingAnchor, constant: 50).active = true
                extraOverlayImageView.image = UIImage(named: overlayLeftImageName)
            case .Right :
                self.trailingAnchor.constraintEqualToAnchor(extraOverlayImageView.trailingAnchor, constant: 50).active = false
                extraOverlayImageView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 50).active = true
                extraOverlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                extraOverlayImageView.image = nil
            }
            
        }
    }
    
}
