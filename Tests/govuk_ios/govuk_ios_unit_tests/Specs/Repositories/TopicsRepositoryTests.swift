import Foundation
import Testing
import CoreData

@testable import govuk_ios

@Suite
struct TopicsRepositoryTests {
    
    let coreData = CoreDataRepository.arrangeAndLoad
    let sut: TopicsRepository

    init() {
        self.sut = TopicsRepository(coreData: coreData)
    }

    @Test
    func saveTopics_doesSaveResponseItems() async throws {
        sut.save(topics: TopicResponseItem.arrangeMultiple)
        let topics = sut.fetchAll()
        #expect(topics.count == 3)
        #expect(topics.first?.title == "Business")
        #expect(topics.first?.ref == "business")
        #expect(topics.filter { $0.isFavorite == true }.count == 3)
        
    }
    
    @Test
    func saveTopics_newTopicsNotFavoritedAfterInitialLaunch() async throws {
        // Given I have started the app the first time, and gotten topics
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

        // Then the new item will not be favorited
        let topics = sut.fetchAll()
        #expect(topics.count == 4)
        let newTopic = try #require(topics.first(where: { $0.ref == "new-item" }))
        #expect(newTopic.isFavorite == false)
    }

    @Test
    func fetchFavorites_onlyReturnsFavorites() async throws {
        let expectedResult = Topic.arrange(context: coreData.viewContext, isFavourite: true)
        Topic.arrange(context: coreData.viewContext, isFavourite: false)

        let favorites = sut.fetchFavorites()
        #expect(favorites.count == 1)
        #expect(favorites.first?.title == expectedResult.title)
    }
    
    @Test
    func save_persistsDataAsExpected() async throws {
        Topic.arrangeMultiple(context: coreData.viewContext)

        sut.save()

        let request = Topic.fetchRequest()
        let context = coreData.backgroundContext
        let topics = try #require(try? context.fetch(request))
        #expect(topics.count == 4)
    }
}
