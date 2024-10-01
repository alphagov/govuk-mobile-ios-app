import Foundation
import Testing

@testable import govuk_ios

@Suite
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
        sut.save(params: params)

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
        sut.save(params: params)

        let request = ActivityItem.fetchRequest()
        let results = try coreData.viewContext.fetch(request)
        #expect(results.count == 2)

        let containsOriginalItem = results.contains { $0.id == originalId }
        #expect(containsOriginalItem)

        let containsNewItem = results.contains { $0.id == newId }
        #expect(containsNewItem)
    }
}
