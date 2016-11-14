//
//  GradientView.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 13/11/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = CGSize(width: frame.width, height: frame.height)
        layer.frame.origin = CGPoint(x: 0.0, y: 0.0)
        //layer.cornerRadius = CGFloat(frame.width / 20)
        
        let color0 = UIColor.black.cgColor
        let color1 = UIColor.clear.cgColor
        
        layer.colors = [color0,color1]
        self.layer.insertSublayer(layer, at: 0)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
    // resize your layers based on the view's new bounds
        self.layer.sublayers?[0].frame=self.bounds
    }
}
