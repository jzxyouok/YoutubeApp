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
            /*
            Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet","regionCode":"US","q":keywordArray[Int(arc4random_uniform(UInt32(keywordArray.count)))],"maxResults":3,"type":"video","videoDuration":"short","videoCategoryId":28,"key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseJSON{ (response) -> Void in
                    if let JSON = response.result.value as? NSDictionary {
                let data: AnyObject? = JSON
                completionHandler(data: data)
                }
            }
             */
            
            Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet","regionCode":"US","q":keywordArray[Int(arc4random_uniform(UInt32(keywordArray.count)))],"maxResults":3,"type":"video","videoDuration":"short","videoCategoryId":28,"key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseObject { (response: Response<Video, NSError>) in
                    let videoResponse = response.result.value as? NSDictionary
                    let data: AnyObject? = videoResponse
                    if let videos = data!["items"] as? [Video] {
                        for video in videos {
                            let videoObj = Video()
                            videoObj.videoId=video.videoId
                            videoObj.snippet!.title=video.snippet!.title
                            videoObj.snippet!.description=video.snippet!.description
                            videoObj.snippet!.thumbnailUrlString=video.snippet!.thumbnailUrlString
                            self.videoArray.append(videoObj)
                        }
                        
                        completionHandler(data: data)
                    }
            }
        }
        
        
        if (interest=="philosophy" || interest == "mathematics" || interest == "geography") {
            Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet","regionCode":"US","q":keywordArray[(counter*10)+Int(arc4random_uniform(UInt32(keywordArray.count)))],"maxResults":3,"type":"video","videoDuration":"short","videoCategoryId":27,"key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseJSON{ (response) -> Void in
                if let JSON = response.result.value as? NSDictionary {
                    let data: AnyObject? = JSON
                    completionHandler(data: data)
                }
            }
        }
        
        
        if (interest=="history") {
            Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet","regionCode":"US","maxResults":3,"q":keywordArray[(counter*10)+Int(arc4random_uniform(UInt32(keywordArray.count)))],"type":"video","videoDuration":"short","videoCategoryId":35,"key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseJSON{ (response) -> Void in
                if let JSON = response.result.value as? NSDictionary {
                    let data: AnyObject? = JSON
                    completionHandler(data: data)
                }
            }
        }

        
        if (interest=="technology") {
            Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/search", parameters: ["part":"snippet","regionCode":"US","maxResults":3,"q":keywordArray[(counter*10)+Int(arc4random_uniform(UInt32(keywordArray.count)))],"type":"video","videoDuration":"short","videoCategoryId":26,"key":API_KEY], encoding: ParameterEncoding.URL, headers: nil).responseJSON{ (response) -> Void in
                if let JSON = response.result.value as? NSDictionary {
                    let data: AnyObject? = JSON
                    completionHandler(data: data)
                }
            }
        }

    }
}
/*
    func getVideos() -> [Video] {

        //Create an empty array of Video objects
        var videos = [Video]()
        
        //Create a video object
        let video1 = Video()
        
        //Assign properties
        video1.videoId="48kekFLZkXU"
        video1.videoTitle="How To Make a YouTube Video App - Ep 03 - Creating the Video Data"
        video1.videoDescription="Lesson 3: In this series, I'll show you guys how to build a video app that plays YouTube videos!"
        //Append it into the videos array
        videos.append(video1)
        
        
        //Create a video object
        let video2 = Video()
        
        //Assign properties
        video2.videoId="wJVjuALsJ0g"
        video2.videoTitle="How To Make an App - Ep 6 - Auto Layout in Xcode 7 (iOS 9)"
        video2.videoDescription="Lesson 6: Auto Layout in Xcode 7. This lesson introduces auto layout in Xcode 7 as we create the user interface for our War card game."
        //Append it into the videos array
        videos.append(video2)
        
        
        //Create a video object
        let video3 = Video()
        
        //Assign properties
        video3.videoId="wJVjuALsJ0g"
        video3.videoTitle="How To Make an App - Ep 6 - Auto Layout in Xcode 7 (iOS 9)"
        video3.videoDescription="Lesson 6: Auto Layout in Xcode 7. This lesson introduces auto layout in Xcode 7 as we create the user interface for our War card game."
        //Append it into the videos array
        videos.append(video3)
        
        
        //Create a video object
        let video4 = Video()
        
        //Assign properties
        video4.videoId="wJVjuALsJ0g"
        video4.videoTitle="How To Make an App - Ep 6 - Auto Layout in Xcode 7 (iOS 9)"
        video4.videoDescription="Lesson 6: Auto Layout in Xcode 7. This lesson introduces auto layout in Xcode 7 as we create the user interface for our War card game."
        //Append it into the videos array
        videos.append(video4)
        
        
        //Create a video object
        let video5 = Video()
        
        //Assign properties
        video5.videoId="wJVjuALsJ0g"
        video5.videoTitle="How To Make an App - Ep 6 - Auto Layout in Xcode 7 (iOS 9)"
        video5.videoDescription="Lesson 6: Auto Layout in Xcode 7. This lesson introduces auto layout in Xcode 7 as we create the user interface for our War card game."
        //Append it into the videos array
        videos.append(video5)
        
        return videos
    }
*/
}
