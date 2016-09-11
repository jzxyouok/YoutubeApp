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
    /*
    lazy var checkmark : SSCheckMark = {
        let checkmark = SSCheckMark()
        checkmark.checkMarkStyle = .OpenCircle
        checkmark.checked = false
        checkmark.backgroundColor=UIColor.clearColor()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(InterestView.checkmarkTapped(_:)))
        checkmark.addGestureRecognizer(gesture)
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        return checkmark
    }()
    
    func checkmarkTapped(recognizer: UITapGestureRecognizer) {
        if !checkmark.checked {
            checkmark.checked=true
        } else {
            checkmark.checked=false
        }
    }
    */
    
    lazy var swich : UISwitch = {
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
    override var tag: Int {
        didSet {
            swich.tag = tag
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
        contentView.addSubview(imageView)
        //imageView.addSubview(checkmark)
        imageView.addSubview(swich)
        imageView.addSubview(label)
        self.userInteractionEnabled = true
        imageView.userInteractionEnabled = true
        
        
        NSLayoutConstraint.activateConstraints(
            [
                imageView.topAnchor.constraintEqualToAnchor(self.topAnchor),
                imageView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor),
                imageView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor),
                imageView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor),
                //imageView.heightAnchor.constraintEqualToConstant(150),
                label.heightAnchor.constraintEqualToAnchor(imageView.heightAnchor, multiplier: 0.2),
                label.leadingAnchor.constraintEqualToAnchor(imageView.leadingAnchor),
                label.bottomAnchor.constraintEqualToAnchor(imageView.bottomAnchor, constant: 0),
                label.trailingAnchor.constraintEqualToAnchor(imageView.trailingAnchor),
                //checkmark.heightAnchor.constraintEqualToConstant(31),
                //checkmark.widthAnchor.constraintEqualToConstant(31),
                swich.heightAnchor.constraintEqualToConstant(31),
                //imageView.trailingAnchor.constraintEqualToAnchor(checkmark.trailingAnchor, constant: 8),
                //checkmark.topAnchor.constraintEqualToAnchor(imageView.topAnchor, constant: 8)
                imageView.trailingAnchor.constraintEqualToAnchor(swich.trailingAnchor, constant: 8),
                swich.topAnchor.constraintEqualToAnchor(imageView.topAnchor, constant: 8)
            ]
            
        )
        
    }
}
