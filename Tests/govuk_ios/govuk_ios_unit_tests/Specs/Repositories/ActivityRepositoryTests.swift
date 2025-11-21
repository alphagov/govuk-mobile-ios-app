import Foundation
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct ActivityRepositoryTests {
    @Test
    func save_existingObject_overwritesObject() throws {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = ActivityRepository(
            coreData: coreData
        )

        let expectedId = UUID().uuidString
        let params = ActivityItemCreateParams(
            id: expectedId,
            title: "title",
            date: .init(timeIntervalSince1970: 0),
            url: "test"
        )
        sut.save(params: params)

        var newParams = params
        let expectedDate = Date()
        newParams.date = expectedDate
        sut.save(params: newParams)

        let request = ActivityItem.fetchRequest()
        let results = try coreData.viewContext.fetch(request)
        #expect(results.count == 1)

        let item = try #require(results.first)
        #expect(item.date == expectedDate)
        #expect(item.id == expectedId)
    }

    @Test
    func save_newObject_savesObject() throws {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = ActivityRepository(
            coreData: coreData
        )

        let originalId = UUID().uuidString
        let params = ActivityItemCreateParams(
            id: originalId,
            title: "title",
            date: .init(timeIntervalSince1970: 0),
            url: "test"
        )
        sut.save(params: params)

        var newParams = params
        let newId = UUID().uuidString
        newParams.id = newId

        let expectedDate = Date()
        newParams.date = expectedDate
        sut.save(params: newParams)

        let request = ActivityItem.fetchRequest()
        let results = try coreData.viewContext.fetch(request)
        #expect(results.count == 2)

        let containsOriginalItem = results.contains { $0.id == originalId }
        #expect(containsOriginalItem)

        let containsNewItem = results.contains { $0.id == newId }
        #expect(containsNewItem)
    }

    @Test
    func deleteObjectIds_removesExpectedObject() throws {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = ActivityRepository(
            coreData: coreData
        )

        let item = ActivityItem.arrange(context: coreData.viewContext)
        let item2 = ActivityItem.arrange(context: coreData.viewContext),
        _ = [
            ActivityItem.arrange(context: coreData.viewContext),
            ActivityItem.arrange(context: coreData.viewContext)
        ]

        try coreData.viewContext.save()

        let request = ActivityItem.fetchRequest()
        let results = try coreData.viewContext.fetch(request)
        try #require(results.count == 4)

        sut.delete(objectIds: [item.objectID, item2.objectID])

        let viewContextResults = try coreData.viewContext.fetch(request)
        #expect(viewContextResults.count == 2)

        let backgroundContextResults = try coreData.backgroundContext.fetch(request)
        #expect(backgroundContextResults.count == 2)
    }

    @Test
    func fetch_returnsControllerWithExpectedObjects() async throws {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = ActivityRepository(
            coreData: coreData
        )

        let controller = sut.fetch()
        #expect(controller.fetchedObjects?.isEmpty == true)
        let mockDelegate = MockFetchedResultsDelegate(
            controller: controller
        )
        let count = await withCheckedContinuation { continuation in

            mockDelegate.firedAction = {
                continuation.resume(returning: controller.fetchedObjects?.count)
            }

            let originalId = UUID().uuidString
            let params = ActivityItemCreateParams(
                id: originalId,
                title: "title",
                date: .init(timeIntervalSince1970: 0),
                url: "test"
            )
            sut.save(params: params)
        }
        #expect(count == 1)
        mockDelegate.retainerMethod()
    }

    @Test
    func activityItemForId_returnsExpectedItem() throws {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = ActivityRepository(
            coreData: coreData
        )

        let context = coreData.backgroundContext

        let originalId = UUID().uuidString
        let params = ActivityItemCreateParams(
            id: originalId,
            title: "title",
            date: .init(timeIntervalSince1970: 0),
            url: "test"
        )
        let activityItem = ActivityItem(context: context)
        activityItem.update(params)
        context.performAndWait {
            try? context.save()
        }

        let item = try #require(try sut.activityItem(for: activityItem.objectID))
        #expect(item.title == "title")
    }
}
