//
//  CustomWebView.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 27/10/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class CustomWebView: UIWebView {

    //var videoId: String!
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        DispatchQueue.main.async {
        //let parameters = ["YouTubeVideoID" : self.videoId]
        //Flurry.logEvent("Video Opened", withParameters: parameters)
        }
    }
    
}
