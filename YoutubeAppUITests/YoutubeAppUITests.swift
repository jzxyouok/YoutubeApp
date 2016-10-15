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
        
        XCUIDevice.shared().orientation = .faceUp
        
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetStartedFunctionality() {
        
        let app = XCUIApplication()
        sleep(2)
        
        if app.buttons["Log In Button"].exists {
            getStartedUserFlow(app: app)
            XCTAssert(app.scrollViews.otherElements.buttons["btn skip normal"].exists)
        } else {
            XCUIApplication().navigationBars["Discover"].buttons["Sign Out"].tap()
            getStartedUserFlow(app: app)
            XCTAssert(app.scrollViews.otherElements.buttons["btn skip normal"].exists)
        }
    }
    
    func testLikedVideoIsStored() {
        let app = XCUIApplication()
        
        if app.buttons["Log In Button"].exists {
            getStartedUserFlow(app: app)
            browsingVideosUserFlow(app: app)
            app.tabBars.buttons["Favorites"].tap()
            XCTAssert(app.tables.element.cells.count>=2, "Liked videos didn't save")
        } else {
            let tabBarsQuery = app.tabBars
            tabBarsQuery.buttons["Favorites"].tap()
            app.navigationBars["Saved Videos"].children(matching: .button).element(boundBy: 0).tap()
            app.tables.staticTexts["Reset saved videos"].tap()
            app.alerts["Are you sure?"].buttons["Ok"].tap()
            app.navigationBars["Settings"].buttons["Saved Videos"].tap()
            tabBarsQuery.buttons["Search"].tap()
            browsingVideosUserFlow(app: app)
            app.tabBars.buttons["Favorites"].tap()
            XCTAssert(app.tables.element.cells.count>=2, "Liked videos didn't save")
        }
    }
    
    func testYouTubeSyncAlertControllerPresentation() {
        let app = XCUIApplication()
        if app.buttons["Log In Button"].exists {
            getStartedUserFlow(app: app)
            app.tabBars.buttons["Favorites"].tap()
            app.navigationBars["Saved Videos"].buttons["Share"].tap()
            XCTAssert(app.alerts["Sync Saved Videos to YouTube"].buttons["Ok"].exists)
        } else {
            app.tabBars.buttons["Favorites"].tap()
            app.navigationBars["Saved Videos"].buttons["Share"].tap()
            XCTAssert(app.alerts["Sync Saved Videos to YouTube"].buttons["Ok"].exists)
        }
    }
    
    func testClearSelectedVideos() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        if app.buttons["Log In Button"].exists {
            getStartedUserFlow(app: app)
            browsingVideosUserFlow(app: app)
            app.tabBars.buttons["Favorites"].tap()
            app.navigationBars["Saved Videos"].buttons["settings 24"].tap()
            app.tables.staticTexts["Reset saved videos"].tap()
            app.alerts["Are you sure?"].buttons["Ok"].tap()
            app.navigationBars["Settings"].buttons["Saved Videos"].tap()
            XCTAssert(app.tables.element.cells.count==0, "Reset saved videos didn't work")
        } else {
            browsingVideosUserFlow(app: app)
            app.tabBars.buttons["Favorites"].tap()
            app.navigationBars["Saved Videos"].buttons["settings 24"].tap()
            app.tables.staticTexts["Reset saved videos"].tap()
            app.alerts["Are you sure?"].buttons["Ok"].tap()
            app.navigationBars["Settings"].buttons["Saved Videos"].tap()
            XCTAssert(app.tables.element.cells.count==0, "Reset saved videos didn't work")
        }
        
    }
    
    func browsingVideosUserFlow(app: XCUIApplication) {
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
        sleep(1)
        btnLikeNormalButton.tap()
        sleep(1)
        btnSkipNormalButton.tap()
        sleep(1)
        btnLikeNormalButton.tap()
        sleep(1)
        btnSkipNormalButton.tap()
    }
    
    func getStartedUserFlow(app: XCUIApplication) {
        
        app.buttons["Log In Button"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.images["philosophy.jpg"].tap()
        collectionViewsQuery.images["physics.jpg"].tap()
        app.navigationBars["YoutubeApp.InterestsView"].buttons["Next"].tap()
        
        let tablesQuery = app.tables
        
        tablesQuery.children(matching: .cell).element(boundBy: 1).staticTexts["Intermediate"].tap()
        tablesQuery.children(matching: .cell).element(boundBy: 3).staticTexts["Beginner"].tap()
        
        let biologyStaticText = tablesQuery.staticTexts["Biology"]
        biologyStaticText.swipeUp()
        tablesQuery.staticTexts["Chemistry"].swipeUp()
        tablesQuery.children(matching: .cell).element(boundBy: 5).staticTexts["Expert"].tap()
        tablesQuery.children(matching: .cell).element(boundBy: 7).staticTexts["Intermediate"].tap()
        app.navigationBars["YoutubeApp.SkillsView"].buttons["Next"].tap()
        app.alerts["Keyword Entry"].buttons["Got it!"].tap()
        
        let window = app.children(matching: .window).element(boundBy: 0)
        let textView = window.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        textView.tap()
        textView.typeText("business startup")
        app.navigationBars["YoutubeApp.KeywordVC"].buttons["Next"].tap()
        sleep(3)
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
