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
            contentId: nil,
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

    @Test
    func activityItemForId_returnsExpectedItem() throws {
        let coreData = CoreDataRepository.arrangeAndLoad
        let activityRepository = ActivityRepository(
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

        let sut = ActivityService(
            repository: activityRepository
        )

        let item = try #require(try sut.activityItem(for: activityItem.objectID))
        #expect(item.title == "title")
    }
}
