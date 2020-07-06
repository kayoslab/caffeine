//
//  caffeineUITests.swift
//  caffeineUITests
//
//  Created by cr0ss on 18.09.15.
//  Copyright © 2015 kayos. All rights reserved.
//

import XCTest

class caffeineUITests: XCTestCase {

    private var app: XCUIApplication?

    override func setUp() {
        super.setUp()

        continueAfterFailure = true
        let app = XCUIApplication()
        setupSnapshot(app)
        self.app = app
        self.app?.launch()
    }

    func testScreenshots() {

        if app?.staticTexts.containing(.init(format: "label CONTAINS[c] %@", "Turn All Categories On")).count ?? 0 > 0 {
            app?.tables.staticTexts["Turn All Categories On"].tap()
            app?.navigationBars["Health Access"].buttons["Allow"].tap()
        } else if app?.staticTexts.containing(.init(format: "label CONTAINS[c] %@", "All Categories On")).count ?? 0 > 0 {
            app?.tables.staticTexts["All Categories On"].tap()
            app?.navigationBars["Health Access"].buttons["Allow"].tap()
        }

        snapshot("0-Consumption")
        let tabBarsQuery = app?.tabBars
        tabBarsQuery?.buttons.allElementsBoundByIndex[1].tap()

        let saveElementsQuery: XCUIElementQuery?

        saveElementsQuery = app?.scrollViews.otherElements.containing(
            .button,
            identifier: "input_save_button"
        )

        saveElementsQuery?.children(matching: .other)
            .element(boundBy: 0)
            .children(matching: .other)
            .element(boundBy: 1)
            .children(matching: .button)
            .element
            .tap()
        saveElementsQuery?
            .children(matching: .other)
            .element(boundBy: 1)
            .children(matching: .other)
            .element(boundBy: 1)
            .children(matching: .button)
            .element
            .tap()
        saveElementsQuery?
            .children(matching: .other)
            .element(boundBy: 2)
            .children(matching: .other)
            .element(boundBy: 0)
            .children(matching: .button)
            .element
            .tap()
        saveElementsQuery?
            .children(matching: .other)
            .element(boundBy: 3)
            .children(matching: .other)
            .element(boundBy: 0)
            .children(matching: .button)
            .element
            .tap()

        snapshot("1-Input")
        app?.scrollViews.otherElements.buttons["input_save_button"].tap()

        tabBarsQuery?.buttons.allElementsBoundByIndex[2].tap()
        snapshot("2-Daily")

        app?.scrollViews.otherElements.buttons.allElementsBoundByIndex[1].tap()
        snapshot("3-Monthly")

        tabBarsQuery?.buttons.allElementsBoundByIndex[3].tap()
        snapshot("4-Settings")
    }
}
