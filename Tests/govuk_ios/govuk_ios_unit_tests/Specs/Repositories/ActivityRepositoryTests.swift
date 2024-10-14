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
    func deleteAll_withData_removesData() throws {
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
        try #require(results.count == 2)

        sut.deleteAll()

        let viewContextResults = try coreData.viewContext.fetch(request)
        #expect(viewContextResults.isEmpty)

        let backgroundContextResults = try coreData.viewContext.fetch(request)
        #expect(backgroundContextResults.isEmpty)
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
}
