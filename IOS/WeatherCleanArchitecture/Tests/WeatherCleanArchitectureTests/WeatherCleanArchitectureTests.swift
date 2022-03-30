import XCTest
@testable import WeatherCleanArchitecture

final class WeatherCleanArchitectureTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(WeatherCleanArchitecture().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
