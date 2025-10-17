import Foundation
import CoreData
import Testing


@testable import govuk_ios

@Suite
@MainActor
struct CoreDataRepositoryTests {
    @Test
    func load_returnsExpectedResult() {
        let sut = CoreDataRepository.arrange
        let result = sut.load()

        #expect(sut === result)
    }

    @Test
    func load_addsViewContextObserver() {
        let mockNotificationCenter = MockNotificationCenter()
        let sut = CoreDataRepository.arrange(
            notificationCenter: mockNotificationCenter
        ).load()

        #expect(mockNotificationCenter._receivedObservers.count == 2)

        let containsContext = mockNotificationCenter._receivedObservers.contains(
            where: { tuple in
                (tuple.object as? NSObject) == sut.viewContext
            }
        )

        #expect(containsContext)
    }

    @Test
    func load_addsBackgroundContextObserver() {
        let mockNotificationCenter = MockNotificationCenter()
        let sut = CoreDataRepository.arrange(
            notificationCenter: mockNotificationCenter
        ).load()

        #expect(mockNotificationCenter._receivedObservers.count == 2)

        let containsContext = mockNotificationCenter._receivedObservers.contains(
            where: { tuple in
                (tuple.object as? NSObject) == sut.backgroundContext
            }
        )

        #expect(containsContext)
    }

    @Test
    func save_viewContext_mergesChanges() throws {
        let sut = CoreDataRepository.arrangeAndLoad

        let item = ActivityItem.arrange(
            context: sut.viewContext
        )

        try sut.viewContext.save()

        let expectedNewTitle = UUID().uuidString
        item.title = expectedNewTitle

        try sut.viewContext.save()

        let request = ActivityItem.fetchRequest()
        let items = try sut.backgroundContext.fetch(request)

        #expect(items.first?.title == expectedNewTitle)
    }

    @Test
    func save_backgroundContext_mergesChanges() throws {
        let sut = CoreDataRepository.arrangeAndLoad

        let item = ActivityItem.arrange(
            context: sut.backgroundContext
        )

        try sut.backgroundContext.save()

        let expectedTitle = UUID().uuidString
        item.title = expectedTitle

        try sut.backgroundContext.save()

        let request = ActivityItem.fetchRequest()
        let items = try sut.viewContext.fetch(request)

        #expect(items.first?.title == expectedTitle)
    }
}
