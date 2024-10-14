import Foundation
import Testing
import CoreData

@testable import govuk_ios

struct TopicsRepositoryTests {
    
    let coreData = CoreDataRepository.arrangeAndLoad
    var sut: TopicsRepository {
        TopicsRepository(coreData: coreData)
    }

    @Test
    func saveTopicsList_doesSaveResponseItems() async throws {
        let topicResponseItems = try #require(try? MockTopicsService.testTopicsResult.get())
        sut.saveTopicsList(topicResponseItems)
        let topics = sut.fetchAllTopics()
        #expect(topics.count == 3)
        #expect(topics.first?.title == "Business")
        #expect(topics.first?.ref == "business")
        #expect(topics.filter { $0.isFavorite == true }.count == 3)
        
    }
    
    @Test func saveTopicsList_newTopicsNotFavoritedAfterInitialLaunch() async throws {
        // Given I have starte the app once and gotten topics
        var topicResponseItems = try #require(try? MockTopicsService.testTopicsResult.get())
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
        createTopics(context: coreData.viewContext)
        let favorites = sut.fetchFavoriteTopics()
        #expect(favorites.count == 1)
        #expect(favorites.first?.title == "title3")
    }
    
    @Test func saveChanges_persistsDataAsExpected() async throws {
        // Given I save on the view context
        createTopics(context: coreData.viewContext)
        // After I save them
        sut.saveChanges()
        // I should be able to fetch on another context
        let request = Topic.fetchRequest()
        let context = coreData.backgroundContext
        let topics = try #require(try? context.fetch(request))
        #expect(topics.count == 4)
    }
    
}

private extension TopicsRepositoryTests {
    @discardableResult
    func createTopics(context: NSManagedObjectContext) -> [Topic] {
        var topics = [Topic]()
        for index in 0..<4 {
            let topic = Topic(context: context)
            topic.ref = "ref\(index)"
            topic.title = "title\(index)"
            topic.isFavorite = index == 3 ? true : false
            topics.append(topic)
        }
        
        return topics
    }

}
