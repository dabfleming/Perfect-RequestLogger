import XCTest
@testable import Perfect_RequestLogger

class Perfect_RequestLoggerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Perfect_RequestLogger().text, "Hello, World!")
    }


    static var allTests : [(String, (Perfect_RequestLoggerTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
