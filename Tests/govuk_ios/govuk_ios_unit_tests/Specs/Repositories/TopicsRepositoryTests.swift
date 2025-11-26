import Foundation
import Testing
import CoreData

@testable import govuk_ios

@Suite
struct TopicsRepositoryTests {
    @Test
    func saveTopics_doesSaveResponseItems() throws {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = TopicsRepository(coreData: coreData)
        sut.save(topics: TopicResponseItem.arrangeMultiple)
        let topics = sut.fetchAll()
        #expect(topics.count == 3)
        #expect(topics.first?.title == "Business")
        #expect(topics.first?.ref == "business")
        #expect(topics.filter { $0.isFavourite == false }.count == 3)
    }
    
    @Test
    func saveTopics_newTopics_savesNewTopics() throws {
        // Given I have started the app the first time, and gotten topics
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = TopicsRepository(coreData: coreData)
        var topicResponseItems = TopicResponseItem.arrangeMultiple
        sut.save(topics: topicResponseItems)

        // When I start the app again and new topics are available to save
        let newItem = TopicResponseItem(
            ref: "new-item",
            title: "New Item",
            description: "Description"
        )
        topicResponseItems.append(newItem)
        sut.save(topics: topicResponseItems)

        // Then the new item will not be Favourited
        let topics = sut.fetchAll()
        #expect(topics.count == 4)
        let newTopic = try #require(topics.first(where: { $0.ref == "new-item" }))
        #expect(newTopic.isFavourite == false)
    }

    @Test
    func saveTopics_updatedTopics_updatesTopics() throws {
        // Given I have started the app the first time, and gotten topics
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = TopicsRepository(coreData: coreData)
        let topicResponseItems: [TopicResponseItem] = [
            .init(ref: "test_1", title: "first title", description: "first description"),
            .init(ref: "test_2", title: "second title", description: nil),
            .init(ref: "test_3", title: "third title", description: "third description"),
        ]
        sut.save(topics: topicResponseItems)

        let firstSave = sut.fetchAll()
        try #require(firstSave.count == 3)

        let favourite = try #require(firstSave.first(where: { $0.ref == "test_1" }))
        favourite.isFavourite = true
        try favourite.managedObjectContext?.save()

        let updatedItems: [TopicResponseItem] = [
            .init(ref: "test_1", title: "first titlez", description: nil),
            .init(ref: "test_2", title: "second titlez", description: "second descrtiption"),
            .init(ref: "test_3", title: "third titlez", description: "third description"),
        ]
        sut.save(topics: updatedItems)

        // Then the new item will not be Favourited
        let topics = sut.fetchAll()
        #expect(topics.count == 3)

        let first = try #require(topics.first(where: { $0.ref == "test_1" }))
        #expect(first.title == "first titlez")
        #expect(first.topicDescription == nil)
        #expect(first.isFavourite == true)

        let second = try #require(topics.first(where: { $0.ref == "test_2" }))
        #expect(second.title == "second titlez")
        #expect(second.topicDescription == "second descrtiption")
        #expect(second.isFavourite == false)

        let third = try #require(topics.first(where: { $0.ref == "test_3" }))
        #expect(third.title == "third titlez")
        #expect(third.topicDescription == "third description")
        #expect(third.isFavourite == false)
    }

    @Test
    func saveTopics_deleteTopics_updatesTopics() throws {
        // Given I have started the app the first time, and gotten topics
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = TopicsRepository(coreData: coreData)
        let topicResponseItems: [TopicResponseItem] = [
            .init(ref: "test_1", title: "first title", description: "first description"),
            .init(ref: "test_2", title: "second title", description: nil),
            .init(ref: "test_3", title: "third title", description: "third description"),
        ]
        sut.save(topics: topicResponseItems)

        let firstSave = sut.fetchAll()
        try #require(firstSave.count == 3)

        let favourite = try #require(firstSave.first(where: { $0.ref == "test_1" }))
        favourite.isFavourite = true
        try favourite.managedObjectContext?.save()

        let updatedItems: [TopicResponseItem] = [
            .init(ref: "test_1", title: "first titlez", description: "description 123"),
        ]
        sut.save(topics: updatedItems)

        // Then the new item will not be Favourited
        let topics = sut.fetchAll()
        #expect(topics.count == 1)



        let first = try #require(topics.first(where: { $0.ref == "test_1" }))
        #expect(first.title == "first titlez")
        #expect(first.topicDescription == "description 123")
        #expect(first.isFavourite == true)
    }

    @Test
    func fetchFavourites_onlyReturnsFavourites() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = TopicsRepository(coreData: coreData)
        let expectedResult = Topic.arrange(context: coreData.viewContext, isFavourite: true)
        Topic.arrange(context: coreData.viewContext, isFavourite: false)

        let Favourites = sut.fetchFavourites()
        #expect(Favourites.count == 1)
        #expect(Favourites.first?.title == expectedResult.title)
    }
    
    @Test
    func save_persistsDataAsExpected() throws {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = TopicsRepository(coreData: coreData)
        Topic.arrange(context: coreData.viewContext)

        let request = Topic.fetchRequest()
        let context = coreData.backgroundContext
        var topics: [Topic]?

        context.performAndWait {
            topics = try? context.fetch(request)
        }
        #expect(topics?.count == 0)

        sut.save()

        context.performAndWait {
            topics = try? context.fetch(request)
        }
        #expect(topics?.count == 1)
    }
}
