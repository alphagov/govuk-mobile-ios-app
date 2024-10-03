import Foundation
import XCTest

@testable import govuk_ios
final class ActivityRepositoryTestsXC: XCTestCase {
    
    var coreData: CoreDataRepository!
    var sut: ActivityRepository!

    override func setUp() {
        super.setUp()
        coreData = CoreDataRepository.arrangeAndLoad
        sut = ActivityRepository(
            coreData: coreData
        )
    }

    override func tearDown() {
        sut = nil
        coreData = nil
        super.tearDown()
    }

    func test_save_existingObject_overwritesObject() throws {
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
        let results = try coreData.backgroundContext.fetch(request)
        XCTAssertEqual(results.count, 1)
        
        let item = try XCTUnwrap(results.first)
        XCTAssertEqual(item.date, expectedDate)
        XCTAssertEqual(item.id, expectedId)
    }
    
    func test_save_newObject_savesObject() throws {
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
        let results = try coreData.backgroundContext.fetch(request)
        XCTAssertEqual(results.count, 2)

        let containsOriginalItem = results.contains { $0.id == originalId }
        XCTAssertTrue(containsOriginalItem)

        let containsNewItem = results.contains { $0.id == newId }
        XCTAssertTrue(containsNewItem)
    }


}
