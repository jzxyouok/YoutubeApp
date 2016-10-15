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
    
    fileprivate lazy var imageView : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    fileprivate lazy var label : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.85)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightRegular)
        return label
    }()
    
    
    lazy var checkmark : SSCheckMark = {
        let checkmark = SSCheckMark()
        checkmark.checkMarkStyle = .openCircle
        checkmark.checked = false
        checkmark.backgroundColor=UIColor.clear
        //let gesture = UITapGestureRecognizer(target: self, action: #selector(InterestView.checkmarkTapped(_:)))
        //checkmark.addGestureRecognizer(gesture)
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        return checkmark
    }()
    /*
    func checkmarkTapped(_ recognizer: UITapGestureRecognizer) {
        if !checkmark.checked {
            checkmark.checked=true
        } else {
            checkmark.checked=false
        }
    }
    */
    /*
    lazy var swich : UISwitch = {
        let swich = UISwitch()
        swich.translatesAutoresizingMaskIntoConstraints = false
        return swich
    }()
    */
    
    fileprivate var spaceConstraint : NSLayoutConstraint!
    
    @IBInspectable
    var spacing: CGFloat = 0.0 {
        didSet {
            spaceConstraint?.constant = spacing
        }
    }
    
    @IBInspectable
    override var tag: Int {
        didSet {
            //swich.tag=tag
            checkmark.tag = tag
        }
    }
    
    @IBInspectable
    var image: UIImage? {
        get {
            return imageView.image
        }
        set(newImage) {
            imageView.image = newImage?.withRenderingMode(.alwaysOriginal)
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
    fileprivate func initialization() {
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        imageView.addSubview(checkmark)
        //imageView.addSubview(swich)
        imageView.addSubview(label)
        self.isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled = true
        
        
        NSLayoutConstraint.activate(
            [
                imageView.topAnchor.constraint(equalTo: self.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                //imageView.heightAnchor.constraintEqualToConstant(150),
                label.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.2),
                label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
                label.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
                label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
                checkmark.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.3),
                checkmark.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.3),
                //swich.heightAnchor.constraint(equalToConstant: 31),
                //imageView.trailingAnchor.constraint(equalTo: checkmark.trailingAnchor, constant: 8),
                checkmark.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 0),
                //checkmark.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
                checkmark.centerXAnchor.constraint(equalTo: imageView.centerXAnchor, constant: 0),
                //imageView.trailingAnchor.constraint(equalTo: swich.trailingAnchor, constant: 8),
                //swich.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8)
            ]
            
        )
        
    }
}
