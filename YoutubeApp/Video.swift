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
    static var selectedVideos = [Video]() {
        didSet {
            let userDefaults = UserDefaults.standard
            let data = NSKeyedArchiver.archivedData(withRootObject: selectedVideos)
            userDefaults.set(data, forKey: "SelectedVideos")
        }
    }
}

class SkillsVideoResponse: NSObject, Mappable {
    
    var videos: [Video] = []
    
    convenience required init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        videos <- map["videos"]
    }
    
}


class VideoResponse: NSObject, Mappable {
    
    var videos: [Video] = []
    
    convenience required init?(map: Map){
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
    
    convenience required init?(map: Map){
        self.init()
        mapping(map: map)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.videoId = aDecoder.decodeObject(forKey: "videoId") as? String
        self.snippet = aDecoder.decodeObject(forKey: "snippet") as? Snippet
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.videoId, forKey: "videoId")
        aCoder.encode(self.snippet, forKey: "snippet")
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
    
    convenience required init?(map: Map){
        self.init()
        mapping(map: map)
        if self.title != nil && self.descriptionn != nil {
            self.title=NSLocalizedString(self.title!, comment: "")
            self.descriptionn=NSLocalizedString(self.descriptionn!, comment: "")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.descriptionn = aDecoder.decodeObject(forKey: "description") as? String
        self.thumbnailUrlString = aDecoder.decodeObject(forKey: "thumbnailUrlString") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.descriptionn, forKey: "description")
        aCoder.encode(self.thumbnailUrlString, forKey: "thumbnailUrlString")
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        descriptionn <- map["description"]
        thumbnailUrlString <- map["thumbnails.default.url"]
    }
    
}
