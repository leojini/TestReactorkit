//
//  TestReactorkitUITests.swift
//  TestReactorkitUITests
//
//  Created by Leojin on 2024/01/14.
//

import XCTest

final class TestReactorkitUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // decrease 버튼
        let button = app.buttons["-"]
        XCTAssertTrue(button.exists)
        button.tap()

        
        // decrease 버튼이 2초 지연되므로 2초 지연 로직 추가
        let expectation = expectation(description: "labelExp")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 2)
        
        // decrease 버튼 이 후 값이 -1됐는지 여부 테스트
        let label = app.staticTexts.element(matching: .any, identifier: "-1")
        XCTAssertTrue(label.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
