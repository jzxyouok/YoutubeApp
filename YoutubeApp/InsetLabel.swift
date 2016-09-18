//
//  InsetLabel.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 11/09/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit

class InsetLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
