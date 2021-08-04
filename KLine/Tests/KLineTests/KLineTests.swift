import XCTest
@testable import KLine

final class KLineTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(KLine().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
