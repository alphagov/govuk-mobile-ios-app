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
    func saveTopicsList_doesSaveResponseItems() async throws {
        sut.saveTopicsList(TopicResponseItem.arrangeMultiple)
        let topics = sut.fetchAllTopics()
        #expect(topics.count == 3)
        #expect(topics.first?.title == "Business")
        #expect(topics.first?.ref == "business")
        #expect(topics.filter { $0.isFavorite == true }.count == 3)
        
    }
    
    @Test
    func saveTopicsList_newTopicsNotFavoritedAfterInitialLaunch() async throws {
        // Given I have started the app the first time, and gotten topics
        var topicResponseItems = TopicResponseItem.arrangeMultiple
        sut.saveTopicsList(topicResponseItems)

        // When I start the app again and new topics are available to save
        let newItem = TopicResponseItem(ref: "new-item", title: "New Item")
        topicResponseItems.append(newItem)
        sut.saveTopicsList(topicResponseItems)
        
        // Then the new item will not be favorited
        let topics = sut.fetchAllTopics()
        #expect(topics.count == 4)
        let newTopic = try #require(topics.first(where: { $0.ref == "new-item" }))
        #expect(newTopic.isFavorite == false)
    }

    @Test
    func fetchFavoriteTopics_onlyReturnsFavorites() async throws {
        let expectedResult = Topic.arrange(context: coreData.viewContext, isFavourite: true)
        Topic.arrange(context: coreData.viewContext, isFavourite: false)

        let favorites = sut.fetchFavoriteTopics()
        #expect(favorites.count == 1)
        #expect(favorites.first?.title == expectedResult.title)
    }
    
    @Test
    func saveChanges_persistsDataAsExpected() async throws {
        Topic.arrangeMultiple(context: coreData.viewContext)

        sut.saveChanges()

        let request = Topic.fetchRequest()
        let context = coreData.backgroundContext
        let topics = try #require(try? context.fetch(request))
        #expect(topics.count == 4)
    }
}
