import Foundation
import CoreData
import XCTest

@testable import govuk_ios

class CoreDataRepositoryTests: XCTestCase {
    func test_load_returnsExpectedResult() {
        let sut = CoreDataRepository.arrange
        let result = sut.load()
        XCTAssert(sut === result)
    }

    func test_load_addsViewContextObserver() {
        let mockNotificationCenter = MockNotificationCenter()
        let sut = CoreDataRepository.arrange(
            notificationCenter: mockNotificationCenter
        )
        _ = sut.load()
        XCTAssertEqual(mockNotificationCenter._receivedObservers.count, 2)
        let containsContext = mockNotificationCenter._receivedObservers.contains(
            where: { tuple in
                (tuple.object as? NSObject) == sut.viewContext
            }
        )
        XCTAssertTrue(containsContext)
    }

    func test_load_addsBackgroundContextObserver() {
        let mockNotificationCenter = MockNotificationCenter()
        let sut = CoreDataRepository.arrange(
            notificationCenter: mockNotificationCenter
        )
        _ = sut.load()
        XCTAssertEqual(mockNotificationCenter._receivedObservers.count, 2)
        let containsContext = mockNotificationCenter._receivedObservers.contains(
            where: { tuple in
                (tuple.object as? NSObject) == sut.backgroundContext
            }
        )
        XCTAssertTrue(containsContext)
    }
}
