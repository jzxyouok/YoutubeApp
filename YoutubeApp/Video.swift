//
//  Video.swift
//  YoutubeApp
//
//  Created by Pranav Kasetti on 10/02/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import UIKit

class Video: Mappable {

    var items: [Item]?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        items <- map["items"]
    }
    
}

class Item: Mappable {
    
    var id: ID?
    var snippet: Snippet?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        snippet <- map["snippet"]
    }
}

class ID: Mappable {
    
    var videoId: String?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        videoId <- map["videoId"]
    }
    
}

class Snippet: Mappable {
    
    var title: String?
    var description: String?
    var thumbnails: Thumbnails?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        thumbnails <- map["thumbnails"]
    }
    
}

class Thumbnails: Mappable {
    
    var Default: Default?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        Default <- map["default"]
    }
    
}

class Default: Mapping {
    
    var url: String?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        url <- map["url"]
        }
            
}