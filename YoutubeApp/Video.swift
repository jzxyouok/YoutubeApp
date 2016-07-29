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

class Video: NSObject, Mappable {
    
    var videoId: String?
    var snippet: Snippet?
    
    convenience required init?(_ map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        videoId <- map["id.videoId"]
        if videoId == nil {
            videoId <- map["id.videoid"]
        }
        snippet <- map["snippet"]
    }
    
}

class Snippet: Mappable {
    
    var title: String?
    var description: String?
    var thumbnailUrlString: String?
    
    convenience required init?(_ map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        thumbnailUrlString <- map["thumbnails.default.url"]
    }
    
}