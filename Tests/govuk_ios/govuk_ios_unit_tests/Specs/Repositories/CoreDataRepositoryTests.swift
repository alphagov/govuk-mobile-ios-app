//import Foundation
//import CoreData
//import XCTest
//
//@testable import govuk_ios
//
//class CoreDataRepositoryTests: XCTestCase {
//    func test_load_returnsExpectedResult() {
//        let sut = CoreDataRepository.arrange
//        let result = sut.load()
//        XCTAssert(sut === result)
//    }
//
//    func test_load_addsViewContextObserver() {
//        let mockNotificationCenter = MockNotificationCenter()
//        let sut = CoreDataRepository.arrange(
//            notificationCenter: mockNotificationCenter
//        )
//        _ = sut.load()
//        XCTAssertEqual(mockNotificationCenter._receivedObservers.count, 2)
//        let containsContext = mockNotificationCenter._receivedObservers.contains(
//            where: { tuple in
//                (tuple.object as? NSObject) == sut.viewContext
//            }
//        )
//        XCTAssertTrue(containsContext)
//    }
//
//    func test_load_addsBackgroundContextObserver() {
//        let mockNotificationCenter = MockNotificationCenter()
//        let sut = CoreDataRepository.arrange(
//            notificationCenter: mockNotificationCenter
//        )
//        _ = sut.load()
//        XCTAssertEqual(mockNotificationCenter._receivedObservers.count, 2)
//        let containsContext = mockNotificationCenter._receivedObservers.contains(
//            where: { tuple in
//                (tuple.object as? NSObject) == sut.backgroundContext
//            }
//        )
//        XCTAssertTrue(containsContext)
//    }
//
//    func test_save_viewContext_mergesChanges() throws {
//        let sut = CoreDataRepository.arrange(
//            notificationCenter: .default
//        ).load()
//
//        let item = ActivityItem(context: sut.viewContext)
//        item.id = UUID().uuidString
//
//        try sut.viewContext.save()
//
//        let expectedId = UUID().uuidString
//        item.id = expectedId
//
//        try sut.viewContext.save()
//
//        let request = ActivityItem.fetchRequest()
//        let items = try sut.backgroundContext.fetch(request)
//
//        XCTAssertEqual(items.first?.id, expectedId)
//    }
//
//    func test_save_backgroundContext_mergesChanges() throws {
//        let sut = CoreDataRepository.arrange(
//            notificationCenter: .default
//        ).load()
//
//        let item = ActivityItem(context: sut.backgroundContext)
//        item.id = UUID().uuidString
//
//        try sut.backgroundContext.save()
//
//        let expectedId = UUID().uuidString
//        item.id = expectedId
//
//        try sut.backgroundContext.save()
//
//        let request = ActivityItem.fetchRequest()
//        let items = try sut.viewContext.fetch(request)
//
//        XCTAssertEqual(items.first?.id, expectedId)
//    }
//}
