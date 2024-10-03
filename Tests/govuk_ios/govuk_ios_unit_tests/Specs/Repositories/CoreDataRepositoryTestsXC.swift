import Foundation
import CoreData
import XCTest

@testable import govuk_ios

final class CoreDataRepositoryTestsXC: XCTestCase {

    var mockNotificationCenter: MockNotificationCenter!
    var sut: CoreDataRepository!
    
    override func setUp()  {
        super.setUp()
        mockNotificationCenter = MockNotificationCenter()
        sut = CoreDataRepository.arrange(
            notificationCenter: mockNotificationCenter
        ).load()
    }

    override func tearDown()  {
        mockNotificationCenter = nil
        sut = nil
        super.tearDown()
    }
    
    func test_load_returnsExpectedResult() {
        let sut = CoreDataRepository.arrange
        let result = sut.load()
        XCTAssertTrue(sut === result)
    }

    func test_load_addsViewContextObserver() {

        XCTAssertEqual(mockNotificationCenter._receivedObservers.count, 2)

        let containsContext = mockNotificationCenter._receivedObservers.contains(
            where: { tuple in
                (tuple.object as? NSObject) == sut.viewContext
            }
        )

        XCTAssertTrue(containsContext)
    }
    
    func test_load_addsBackgroundContextObserver() {

        XCTAssertEqual(mockNotificationCenter._receivedObservers.count, 2)

        let containsContext = mockNotificationCenter._receivedObservers.contains(
            where: { tuple in
                (tuple.object as? NSObject) == sut.backgroundContext
            }
        )

        XCTAssertTrue(containsContext)
    }

    func test_save_viewContext_mergesChanges() throws {

        let item = ActivityItem.arrange(
            context: sut.viewContext
        )

        try sut.viewContext.save()

        let expectedNewTitle = UUID().uuidString
        item.title = expectedNewTitle

        try sut.viewContext.save()

        let request = ActivityItem.fetchRequest()
        let items = try sut.backgroundContext.fetch(request)

        XCTAssertEqual(items.first?.title, expectedNewTitle)
    }
    
    func test_save_backgroundContext_mergesChanges() throws {

        let item = ActivityItem.arrange(
            context: sut.backgroundContext
        )

        try sut.backgroundContext.save()

        let expectedTitle = UUID().uuidString
        item.title = expectedTitle

        try sut.backgroundContext.save()

        let request = ActivityItem.fetchRequest()
        let items = try sut.viewContext.fetch(request)

        XCTAssertEqual(items.first?.title, expectedTitle)
    }


}
