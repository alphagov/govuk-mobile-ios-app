import UIKit
import Foundation
import XCTest

import Resolver

@testable import govuk_ios

class TestServiceTests: XCTestCase {

    func test_init_createsService() {
        Resolver.main.register(
            TestDataStoreInterface.self,
            factory: { MockTestDataStore() }
        )
        Resolver.main.register(
            TestNetworkClientInterface.self,
            factory: { MockTestNetworkClient() }
        )
        let subject: TestService? = TestService()
        XCTAssertNotNil(subject)
    }
}

class MockTestDataStore: TestDataStoreInterface {

}

class MockTestNetworkClient: TestNetworkClientInterface {

}
