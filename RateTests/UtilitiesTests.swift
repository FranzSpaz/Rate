import XCTest
import Foundation
@testable import Rate

class UtilitiesTests: XCTestCase {
	func testIgnoreInput() {
		let willBeCalled = expectationWithDescription("willBeCalled")

		let shouldBeCalled: () -> () = {
			willBeCalled.fulfill()
		}

		let willCall: Int -> () = ignoreInput(shouldBeCalled)

		willCall(3)

		waitForExpectationsWithTimeout(1, handler: nil)
	}
}
