import Foundation
import Testing
import CoreData

@testable import govuk_ios

@Suite
struct ActivityServiceTests {

    @Test
    func save_searchItem_savesItem() throws {
        let mockRepository = MockActivityRepository()
        let sut = ActivityService(
            repository: mockRepository
        )
        let expectedTitle = UUID().uuidString
        let expectedURLString = "https://www.govuk.com/test"
        let expectedItem = SearchItem(
            title: expectedTitle,
            description: "test_description",
            link: URL(string: "https://www.govuk.com/test")!
        )
        sut.save(searchItem: expectedItem)

        let receivedParams = mockRepository._receivedSaveParams
        #expect(receivedParams?.id == expectedURLString)
        #expect(receivedParams?.title == expectedTitle)
        #expect(receivedParams?.url == expectedURLString)
        let receivedDate = try #require(receivedParams?.date)
        let calendar = Calendar.current
        let equalDates = calendar.isDate(
            receivedDate,
            equalTo: .init(),
            toGranularity: .second
        )
        #expect(equalDates)
    }

    @Test
    func save_topicContent_savesItem() throws {
        let mockRepository = MockActivityRepository()
        let sut = ActivityService(
            repository: mockRepository
        )
        let expectedTitle = UUID().uuidString
        let expectedURLString = "https://www.govuk.com/test"
        let expectedItem = TopicDetailResponse.Content(
            title: expectedTitle,
            description: "test_description",
            isStepByStep: false,
            popular: false,
            url: URL(string: "https://www.govuk.com/test")!
        )
        sut.save(topicContent: expectedItem)

        let receivedParams = mockRepository._receivedSaveParams
        #expect(receivedParams?.id == expectedURLString)
        #expect(receivedParams?.title == expectedTitle)
        #expect(receivedParams?.url == expectedURLString)
        let receivedDate = try #require(receivedParams?.date)
        let calendar = Calendar.current
        let equalDates = calendar.isDate(
            receivedDate,
            equalTo: .init(),
            toGranularity: .second
        )
        #expect(equalDates)
    }

    @Test
    func fetch_callsRepository() throws {
        let mockRepository = MockActivityRepository()
        let sut = ActivityService(
            repository: mockRepository
        )
        let expectedController = NSFetchedResultsController<ActivityItem>()
        mockRepository._stubbedFetchResultsController = expectedController

        let result = sut.fetch()

        #expect(result == expectedController)
    }

    @Test
    func deleteObjectIds_callsRepository() throws {
        let mockRepository = MockActivityRepository()
        let sut = ActivityService(
            repository: mockRepository
        )

        let expectedId = NSManagedObjectID()
        sut.delete(objectIds: [expectedId])

        #expect(mockRepository._receivedDeleteObjectIds?.count == 1)
        #expect(mockRepository._receivedDeleteObjectIds?.first == expectedId)
    }
}
