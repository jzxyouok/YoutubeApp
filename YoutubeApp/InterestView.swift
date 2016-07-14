//
//  InterestView.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 28/06/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit

@IBDesignable
class InterestView: UICollectionViewCell {
    
    private lazy var imageView : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var label : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.85)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFontOfSize(17.0, weight: UIFontWeightRegular)
        return label
    }()
    
    private lazy var swich : UISwitch = {
        let swich = UISwitch()
        swich.translatesAutoresizingMaskIntoConstraints = false
        return swich
    }()
    
    private var spaceConstraint : NSLayoutConstraint!
    
    @IBInspectable
    var spacing: CGFloat = 0.0 {
        didSet {
            spaceConstraint?.constant = spacing
        }
    }
    
    @IBInspectable
    var image: UIImage? {
        get {
            return imageView.image
        }
        set(newImage) {
            imageView.image = newImage?.imageWithRenderingMode(.AlwaysOriginal)
        }
    }
    
    @IBInspectable
    var text: String? {
        get {
            return label.text
        }
        set(newText) {
            label.text = newText
        }
    }
    
    @IBInspectable
    override var tag: Int {
        get {
            return swich.tag
        }
        set(newTag) {
            swich.tag = newTag
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
}

extension InterestView {
    private func initialization() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.addSubview(swich)
        imageView.addSubview(label)
        //self.userInteractionEnabled = true
        imageView.userInteractionEnabled = true
        
        
        NSLayoutConstraint.activateConstraints(
            [
                imageView.topAnchor.constraintEqualToAnchor(self.topAnchor),
                imageView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor),
                imageView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor),
                imageView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor),
                imageView.heightAnchor.constraintEqualToConstant(150),
                label.heightAnchor.constraintEqualToConstant(25),
                label.leadingAnchor.constraintEqualToAnchor(imageView.leadingAnchor),
                label.bottomAnchor.constraintEqualToAnchor(imageView.bottomAnchor, constant: 0),
                label.trailingAnchor.constraintEqualToAnchor(imageView.trailingAnchor),
                label.topAnchor.constraintEqualToAnchor(swich.bottomAnchor, constant: 86),
                imageView.trailingAnchor.constraintEqualToAnchor(swich.trailingAnchor, constant: 8),
                swich.topAnchor.constraintEqualToAnchor(imageView.topAnchor, constant: 8)
            ]
        )
        
    }
}
