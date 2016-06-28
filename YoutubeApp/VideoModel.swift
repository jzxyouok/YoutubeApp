//
//  VideoModel.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 10/02/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import AlamofireObjectMapper
import ObjectMapper

protocol VideoModelDelegate {
    func dataReady()
}

class VideoModel: NSObject {
    
    let API_KEY = "AIzaSyD0PN3sI5uWai__bJ_Xv-IV83XnSQ15s48"
    let UPLOADS_PLAYLIST_ID="PLkhUBDAcva4YFHjhFqyG0hY4E6_wW-7uM"
    
    var videoArray = [Video] ()
    var keywordArray = [String] ()
    var keywordArray2 = [String] ()
    var categoryIdArray = [Int] ()
    var done: Int = 0
    
    var delegate:VideoModelDelegate?
    
    func generateKeywords(keywordArray: [String], completionHandler:(data: [String]) -> ()) -> () {
        
        for i in 0..<keywordArray.count {
            
            makeKeywordsRequest(keywordArray, i: i, completionHandler: completionHandler)
            
        }
        
    }
    
    func getFeedVideos(interestArray: [String], keywordArray: [String], completionHandler:(data: AnyObject?) -> ()) -> () {
        
        //Category Id's: 35 - Documentary, 34 - Comedy, 28 - Science & Technology, 27 - Education, 26 - Howto & Style, 21 - Videoblogging, 2 - Autos & Vehicles,
        
        for interest in interestArray {
            
            if (interest=="biology" || interest=="chemistry" || interest=="physics") {
                makeVideosRequest(28, keywordArray: keywordArray, completionHandler: completionHandler)
            }
            
            
            if (interest=="philosophy" || interest == "mathematics" || interest == "geography") {
                makeVideosRequest(27, keywordArray: keywordArray, completionHandler: completionHandler)
            }
            
            
            if (interest=="history") {
                makeVideosRequest(35, keywordArray: keywordArray, completionHandler: completionHandler)
            }
            
            
            if (interest=="technology") {
                makeVideosRequest(26, keywordArray: keywordArray, completionHandler: completionHandler)
            }
            
        }
    }
    
    func makeVideosRequest(categoryId: Int, keywordArray: [String], completionHandler:(data: AnyObject?) -> ()) -> () {
        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet","regionCode":"US","q":keywordArray[Int(arc4random_uniform(UInt32(keywordArray.count)))],"maxResults":3,"type":"video","videoDuration":"short","videoCategoryId":categoryId,"key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseObject { (response: Response<VideoResponse, NSError>) in
            let videoResponse = response.result.value
            if let videos = videoResponse?.videos {
                for video in videos {
                    self.videoArray.append(video)
                }
                completionHandler(data: self.videoArray)
            }
        }
    }
    
    func makeKeywordsRequest(keywordArray: [String], i: Int, completionHandler:(data: [String]) -> ()) -> () {
        
        let letters : NSString = "abcdefghiklmnoprstuvwxy"
        let randomString : NSMutableString = NSMutableString(capacity: 1)
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        
        Alamofire.request(.GET, "https://api.datamuse.com/words", parameters: ["ml": keywordArray[i], "sp": "*"+(randomString as String)], encoding: ParameterEncoding.URL, headers: nil).responseJSON{ (response) -> Void in
            if let JSON = response.result.value as? [AnyObject] {
                for word in JSON {
                    self.keywordArray2.append(word.valueForKeyPath("word") as! String)
                }
                if self.keywordArray2.count < 10 {
                    self.makeKeywordsRequest(keywordArray, i: i, completionHandler: completionHandler)
                } else {
                    completionHandler(data: self.keywordArray2)
                }
            } else {
                if let error = response.result.error {
                    print (error)
                }
            }
        }
    }
}
