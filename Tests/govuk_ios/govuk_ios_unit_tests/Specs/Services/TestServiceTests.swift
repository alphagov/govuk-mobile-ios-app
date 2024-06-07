import UIKit
import Foundation
import XCTest

@testable import govuk_ios

class TestServiceTests: XCTestCase {

    func test_init_createsService() {
        let subject: TestService? = TestService(
            dataStore: MockTestDataStore(),
            networkClient: MockTestNetworkClient()
        )
        XCTAssertNotNil(subject)
    }
}

class MockTestDataStore: TestDataStoreInterface {

}

class MockTestNetworkClient: TestNetworkClientInterface {

}
