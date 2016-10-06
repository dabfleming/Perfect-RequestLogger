import XCTest
@testable import PerfectRequestLogger

class PerfectRequestLoggerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(PerfectRequestLogger().text, "Hello, World!")
    }


    static var allTests : [(String, (PerfectRequestLoggerTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
