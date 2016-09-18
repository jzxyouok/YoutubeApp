//
//  Thumbnail.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 18/05/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit
import QuartzCore

class Thumbnail: UIView {
    
    // MARK: Properties
    /*
     var rating = 0 {
     didSet {
     setNeedsLayout()
     }
     }
     var ratingButtons = [UIButton]()
     let spacing = 10
     let starCount = 5
     */
    var border = UIView()
    var iv = UIImageView()
    var videoLabel = InsetLabel()
    var videoImage = UIImage()
    
    // MARK: Initialisation
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        iv.image = videoImage
        self.border.backgroundColor=UIColor.clear
        self.border.layer.borderColor=UIColor.orange.cgColor
        self.border.layer.borderWidth=3
        videoLabel.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        videoLabel.textColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        videoLabel.font = UIFont(name: "Helvetica", size: 20)
        videoLabel.textAlignment = .center
        videoLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        videoLabel.numberOfLines = 0
        addSubview(iv)
        addSubview(border)
        border.addSubview(videoLabel)
        /*
         let filledStarImage = UIImage(named: "filledStar")
         let emptyStarImage = UIImage(named: "emptyStar")
         
         for _ in 0..<starCount {
         let button = UIButton()
         
         button.setImage(emptyStarImage, forState: .Normal)
         button.setImage(filledStarImage, forState: .Selected)
         button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
         button.adjustsImageWhenHighlighted = false
         
         button.addTarget(self, action: #selector(Thumbnail.ratingButtonTapped(_:)), forControlEvents: .TouchDown)
         ratingButtons += [button]
         
         addSubview(button)
         }
         */
    }
    
    override func layoutSubviews() {
        // Set the button's width and height to a square the size of the frame's height.
        let imageSize = Int(frame.size.width)
        let labelSize = Int(frame.size.height/3)
        
        let imageFrame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        /*
         // Offset each button's origin by the length of the button plus spacing.
         for (index, button) in ratingButtons.enumerate() {
         buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
         button.frame = buttonFrame
         }
         */
        let borderFrame = imageFrame.insetBy(dx: 10, dy: 10)
        let labelFrame = CGRect(x: 0, y: imageSize-labelSize-10, width: Int(borderFrame.width), height: labelSize-10)
        
        self.border.frame=borderFrame
        
        self.iv.frame = imageFrame
        
        self.videoLabel.frame = labelFrame
        
        //updateButtonSelectionStates()
        
    }
    /*
     override func intrinsicContentSize() -> CGSize {
     let buttonSize = Int(frame.size.height/7)
     let width = (buttonSize * starCount) + (spacing * (starCount - 1))
     
     return CGSize(width: width, height: buttonSize)
     }
     */
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    /*
     // MARK: Button Action
     func ratingButtonTapped(button: UIButton) {
     //print("Button pressed 👍")
     rating = ratingButtons.indexOf(button)! + 1
     
     updateButtonSelectionStates()
     }
     */
    /*
     func updateButtonSelectionStates() {
     
     for (index, button) in ratingButtons.enumerate() {
     // If the index of a button is less than the rating, that button should be selected.
     button.selected = index < rating
     }
     
     }
     */
}
