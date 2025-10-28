//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Vladimir Generalov on 26.10.2025.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = true
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    func testYesButton() {
        sleep(3)
        let firstPosterData = app.images["Poster"].screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        sleep(3)
        let secondPosterData = app.images["Poster"].screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testNoButton() {
        sleep(3)
        let firstPosterData = app.images["Poster"].screenshot().pngRepresentation
        app.buttons["No"].tap()
        sleep(3)
        let secondPosterData = app.images["Poster"].screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testIncrementIndexLabel() {
        sleep(3)
        let indexLabel = app.staticTexts["Index"]
        let indexLabelText = indexLabel.label
        app.buttons["Yes"].tap()
        sleep(3)
        XCTAssertNotEqual(indexLabelText, "2/10")
    }
    
    func testQuizResultAlertContent() {
        for _ in 1...10 {
            sleep(3)
            app.buttons["Yes"].tap()
        }
        
        sleep(3)
        let alert = app.alerts["alert"]
        let alertTitle = alert.label
        let alertButtonText = alert.buttons.firstMatch.label
        
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alertTitle, "Этот раунд окончен!")
        XCTAssertEqual(alertButtonText, "Сыграть ещё раз")
    }
    
    func testAlertDismissAndQuizRestart() {
        for _ in 1...10 {
            sleep(3)
            app.buttons["Yes"].tap()
        }
        
        let alert = app.alerts["alert"]
        alert.buttons.firstMatch.tap()
        
        sleep(3)
        
        let indexLabelText = app.staticTexts["Index"].label
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(indexLabelText, "1/10")
    }
    
    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
