import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    let timeout = 5.0

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
        // Given
        let poster = app.images[UIIdentifiers.Images.poster]
        let yesButton = app.buttons[UIIdentifiers.Buttons.yes]

        // When
        XCTAssertTrue(poster.waitForExistence(timeout: timeout), "Постер не найден перед нажатием кнопки 'Да'")
        let firstPosterData = poster.screenshot().pngRepresentation

        XCTAssertTrue(yesButton.waitForExistence(timeout: timeout), "'Да' кнопка не найдена")
        yesButton.tap()

        XCTAssertTrue(poster.waitForExistence(timeout: timeout), "Постер не обновился после нажатия кнопки 'Да'")
        let secondPosterData = poster.screenshot().pngRepresentation

        // Then
        XCTAssertNotEqual(firstPosterData, secondPosterData, "Постер не изменился после нажатия кнопки 'Да'")
    }
    
    func testNoButton() {
        // Given
        
        let poster = app.images[UIIdentifiers.Images.poster]
        let noButton = app.buttons[UIIdentifiers.Buttons.no]

        // When
        
        XCTAssertTrue(poster.waitForExistence(timeout: timeout), "Постер не найден перед нажатием кнопки 'Нет'")
        let firstPosterData = poster.screenshot().pngRepresentation

        XCTAssertTrue(noButton.waitForExistence(timeout: timeout), "'Нет' кнопка не найдена")
        noButton.tap()

        XCTAssertTrue(poster.waitForExistence(timeout: timeout), "Постер не обновился после нажатия кнопки 'Нет'")
        let secondPosterData = poster.screenshot().pngRepresentation

        // Then
        
        XCTAssertNotEqual(firstPosterData, secondPosterData, "Постер не изменился после нажатия кнопки 'Нет'")
    }
    
    func testIncrementIndexLabel() {
        // Given
        
        let indexLabel = app.staticTexts[UIIdentifiers.StaticTexts.index]
        let yesButton = app.buttons[UIIdentifiers.Buttons.yes]
        
        // When
        
        XCTAssertTrue(indexLabel.waitForExistence(timeout: timeout), "Номер вопроса не найден перед нажатием кнопки 'Да'")
        let indexLabelText = indexLabel.label
        
        XCTAssertTrue(yesButton.waitForExistence(timeout: timeout), "'Да' кнопка не найдена")
        yesButton.tap()
        
        XCTAssertTrue(indexLabel.waitForExistence(timeout: timeout), "Номер вопроса не найден после нажатия кнопки 'Да'")

        // Then
        
        XCTAssertNotEqual(indexLabelText, "2/10", "Номер вопроса не увеличился после нажатия кнопки 'Да'")
    }
    
    func testQuizResultAlertContent() {
        // Given
        
        let yesButton = app.buttons[UIIdentifiers.Buttons.yes]
        let roundCompletedAlert = app.alerts[UIIdentifiers.Alerts.roundCompleted]
        let playAgainButton = roundCompletedAlert.buttons[UIIdentifiers.Alerts.playAgain]
        
        // When
        
        for _ in 1...10 {
            XCTAssertTrue(yesButton.waitForExistence(timeout: timeout), "'Да' кнопка не найдена")
            yesButton.tap()
        }
    
        // Then
        
        XCTAssertTrue(roundCompletedAlert.waitForExistence(timeout: timeout), "Алерт с результатом не появился")
        XCTAssertEqual(roundCompletedAlert.label, "Этот раунд окончен!", "Неверный заголовок алерта")
        XCTAssertTrue(playAgainButton.exists, "Кнопка повторного запуска не найдена")
        XCTAssertEqual(playAgainButton.label, "Сыграть ещё раз", "Неверный текст на кнопке алерта")
    }
    
    func testAlertDismissAndQuizRestart() {
        // Given
        
        let yesButton = app.buttons[UIIdentifiers.Buttons.yes]
        let roundCompletedAlert = app.alerts[UIIdentifiers.Alerts.roundCompleted]
        let playAgainButton = roundCompletedAlert.buttons[UIIdentifiers.Alerts.playAgain]
        let indexLabel = app.staticTexts[UIIdentifiers.StaticTexts.index]
        
        // When
        
        for _ in 1...10 {
            XCTAssertTrue(yesButton.waitForExistence(timeout: timeout), "'Да' кнопка не найдена")
            yesButton.tap()
        }
        XCTAssertTrue(roundCompletedAlert.waitForExistence(timeout: timeout), "Алерт с результатом не появился")
        XCTAssertTrue(playAgainButton.waitForExistence(timeout: timeout), "Кнопка повторного запуска не найдена")
        playAgainButton.tap()
    
        // Then
        
        XCTAssertTrue(indexLabel.waitForExistence(timeout: timeout), "Номер вопроса не найден после перезапуска")
        XCTAssertEqual(indexLabel.label, "1/10", "Квиз не начался с первого вопроса")
    }
}
