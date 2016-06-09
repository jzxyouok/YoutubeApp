//
//  VideoModel.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 10/02/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
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
    
    func generateKeywords(keyword: String, completionHandler:(data: [AnyObject]) -> ()) -> () {
        
        //let myURLString = "https://api.datamuse.com/words"
        
        //let myURL = NSURL(string: myURLString)
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyz"
        
        var randomString : NSMutableString = NSMutableString(capacity: 1)
        
        for (var i=0; i < 1; i += 1){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        Alamofire.request(.GET, "https://api.datamuse.com/words", parameters: ["ml": keyword, "sp": "*"+(randomString as String)], encoding: ParameterEncoding.URL, headers: nil).responseJSON{ (response) -> Void in
            if let JSON = response.result.value as? [AnyObject] {
                completionHandler(data: JSON)
            } else {
                if let error = response.result.error {
                    print (error)
                }
            }
        }
        
        
        /*
        do {
            let myHTMLString = try NSString(contentsOfURL: myURL!, encoding: NSUTF8StringEncoding)
            
            if let doc = Kanna.HTML(html: myHTMLString as String, encoding: NSUTF8StringEncoding) {
                // Search for nodes by XPath
                for link in doc.body!.xpath("//span[@class[contains(.,'res res')]]") {
                    let string = (link.text)!.substringToIndex((link.text)!.startIndex.advancedBy(50, limit: (link.text)!.endIndex))
                    self.keywordArray.append(string)
                }
                var counter=10
                while (counter>0) {
                    let index = Int(arc4random_uniform(UInt32(self.keywordArray.count)))
                    (self.keywordArray2).append((self.keywordArray)[index])
                    counter--
                }
            }
            
        } catch _ {
            let myHTMLString = ""
        }
        */
    }
    func getFeedVideos(interestArray: [String], keywordArray: [String], completionHandler:(data: AnyObject?) -> ()) -> () {
    
    //Category Id's: 35 - Documentary, 34 - Comedy, 28 - Science & Technology, 27 - Education, 26 - Howto & Style, 21 - Videoblogging, 2 - Autos & Vehicles,
    
    var counter = 0
    
    var arrayOfVideos = [Video]()
    
    for interest in interestArray {
        
        if (interest=="biology" || interest=="chemistry" || interest=="physics") {
            
            Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet","regionCode":"US","q":keywordArray[Int(arc4random_uniform(UInt32(keywordArray.count)))],"maxResults":3,"type":"video","videoDuration":"short","videoCategoryId":28,"key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseObject { (response: Response<VideoResponse, NSError>) in
                    let videoResponse = response.result.value
                    if let videos = videoResponse?.videos {
                        for video in videos {
                            self.videoArray.append(video)
                        }
                        completionHandler(data: videoResponse)
                    }
            }
        }
        
        
        if (interest=="philosophy" || interest == "mathematics" || interest == "geography") {
            Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet","regionCode":"US","q":keywordArray[(counter*10)+Int(arc4random_uniform(UInt32(keywordArray.count)))],"maxResults":3,"type":"video","videoDuration":"short","videoCategoryId":27,"key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseObject { (response: Response<VideoResponse, NSError>) in
                let videoResponse = response.result.value
                if let videos = videoResponse?.videos {
                    for video in videos {
                        self.videoArray.append(video)
                    }
                    completionHandler(data: videoResponse)
                }
            }
        }
        
        
        if (interest=="history") {
            Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet","regionCode":"US","maxResults":3,"q":keywordArray[(counter*10)+Int(arc4random_uniform(UInt32(keywordArray.count)))],"type":"video","videoDuration":"short","videoCategoryId":35,"key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseObject { (response: Response<VideoResponse, NSError>) in
                let videoResponse = response.result.value
                if let videos = videoResponse?.videos {
                    for video in videos {
                        self.videoArray.append(video)
                    }
                    completionHandler(data: videoResponse)
                }
            }
        }

        
        if (interest=="technology") {
            Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet","regionCode":"US","maxResults":3,"q":keywordArray[(counter*10)+Int(arc4random_uniform(UInt32(keywordArray.count)))],"type":"video","videoDuration":"short","videoCategoryId":26,"key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseObject { (response: Response<VideoResponse, NSError>) in
                let videoResponse = response.result.value
                if let videos = videoResponse?.videos {
                    for video in videos {
                        self.videoArray.append(video)
                    }
                    completionHandler(data: videoResponse)
                }
            }
        }

    }
}
}
