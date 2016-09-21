//
//  YoutubeAppTests.swift
//  YoutubeAppTests
//
//  Created by Pranav Kasetti on 21/09/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import XCTest
@testable import YoutubeApp

class YoutubeAppTests: XCTestCase {
    
    var videoModel: VideoModel!
    
    override func setUp() {
        super.setUp()
        
        videoModel = VideoModel()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVideosRequest() {
        self.videoModel.videoArray=[]
        self.videoModel.makeVideosRequest(21, keywordArray: ["startup", "business", "lean"], completionHandler: {_ in
            XCTAssertTrue(self.videoModel.videoArray.count > 0, "Network request should update video array in model")
        })
    }
    
    func testSkillsVideoRequest() {
        self.videoModel.videoArray=[]
        self.videoModel.makeSkillsVideosRequest(self.videoModel.physics, keywordArray: ["quantum", "tunneling", "mesons"], completionHandler: {_ in
            XCTAssertTrue(self.videoModel.videoArray.count > 0, "Network request should update video array in model")
        })
    }
    
    func testMakeKeywordsRequest() {
        
    self.videoModel.keywordArray2=[]
    self.videoModel.makeKeywordsRequest(["physics", "biology", "chemistry"], i: 2, completionHandler: {_ in
        XCTAssertTrue(self.videoModel.keywordArray2.count > 0, "Network request should update keywords array in model")
    })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
