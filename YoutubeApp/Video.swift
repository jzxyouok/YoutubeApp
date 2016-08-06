//
//  Video.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 10/02/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper

class VideoStatus: NSObject {
    static var selectedVideos = [Video]()
}

class SkillsVideoResponse: NSObject, Mappable {
    
    var videos: [Video] = []
    
    convenience required init?(_ map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        videos <- map["videos"]
    }
    
}


class VideoResponse: NSObject, Mappable {
    
    var videos: [Video] = []
    
    convenience required init?(_ map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        videos <- map["items"]
    }
    
}

class Video: NSObject, NSCoding, Mappable {
    
    var videoId: String?
    var snippet: Snippet?
    
    override init() {}
    
    convenience required init?(_ map: Map){
        self.init()
        mapping(map)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.videoId = aDecoder.decodeObjectForKey("videoId") as? String
        self.snippet = aDecoder.decodeObjectForKey("snippet") as? Snippet
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.videoId, forKey: "videoId")
        aCoder.encodeObject(self.snippet, forKey: "snippet")
    }
    
    func mapping(map: Map) {
        videoId <- map["id.videoId"]
        if videoId == nil {
            videoId <- map["id.videoid"]
        }
        snippet <- map["snippet"]
    }
    
}

class Snippet: NSObject, NSCoding, Mappable {
    
    var title: String?
    var descriptionn: String?
    var thumbnailUrlString: String?
    
    override init() {}
    
    convenience required init?(_ map: Map){
        self.init()
        mapping(map)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.title = aDecoder.decodeObjectForKey("title") as? String
        self.descriptionn = aDecoder.decodeObjectForKey("description") as? String
        self.thumbnailUrlString = aDecoder.decodeObjectForKey("thumbnailUrlString") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.descriptionn, forKey: "description")
        aCoder.encodeObject(self.thumbnailUrlString, forKey: "thumbnailUrlString")
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        descriptionn <- map["description"]
        thumbnailUrlString <- map["thumbnails.default.url"]
    }
    
}