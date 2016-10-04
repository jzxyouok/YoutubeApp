//
//  YoutubeAppUITests.swift
//  YoutubeAppUITests
//
//  Created by Pranav Kasetti on 27/09/2016.
//  Copyright © 2016 Pranav Kasetti. All rights reserved.
//

import XCTest

class YoutubeAppUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testClearSelectedVideos() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        XCUIDevice.shared().orientation = .faceUp
        
        let app = XCUIApplication()
        let undoButton: XCUIElement = app.scrollViews.otherElements.buttons["btn undo"]
        
        let elementsQuery = app.scrollViews.otherElements
        let btnLikeNormalButton = elementsQuery.buttons["btn like normal"]
        let btnSkipNormalButton = elementsQuery.buttons["btn skip normal"]
        
        self.waitForElementToAppear(element: undoButton)
        self.waitForElementToAppear(element: btnLikeNormalButton)
        self.waitForElementToAppear(element: btnSkipNormalButton)
        
        sleep(3)
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Search"].tap()
        btnLikeNormalButton.tap()
        sleep(1)
        btnSkipNormalButton.tap()
        sleep(1)
        btnLikeNormalButton.tap()
        sleep(1)
        btnSkipNormalButton.tap()
        tabBarsQuery.buttons["Favorites"].tap()
        app.navigationBars["Saved Videos"].buttons["settings 24"].tap()
        app.tables.staticTexts["Reset saved videos"].tap()
        app.alerts["Are you sure?"].buttons["Ok"].tap()
        app.navigationBars["Settings"].buttons["Saved Videos"].tap()
        
        XCTAssert(app.staticTexts.cells.count==0, "Reset saved videos didn't work")
        
    }
    
    func waitForElementToAppear(element: XCUIElement, timeout: TimeInterval = 5,  file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectation(for: existsPredicate,
                    evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: timeout) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }

}
