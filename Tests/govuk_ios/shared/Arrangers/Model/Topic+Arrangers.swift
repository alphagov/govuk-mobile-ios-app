import Foundation
import CoreData

@testable import govuk_ios

extension Topic {

    static func arrangeMultipleFavourites(context: NSManagedObjectContext) -> [Topic] {
        let values: [(ref: String, title: String)] = [
            (ref: "driving-transport", title: "Driving & Transport"),
            (ref: "care", title: "Care"),
            (ref: "business", title: "Business")
        ]

        var topics = [Topic]()
        for response in values {
            let topic = Topic(context: context)
            topic.ref = response.ref
            topic.title = response.title
            topic.isFavorite = true
            topics.append(topic)
        }
        return topics
    }

    @discardableResult
    static func arrangeMultiple(context: NSManagedObjectContext) -> [Topic] {
        var topics = [Topic]()
        for index in 0..<4 {
            let topic = Topic.arrange(
                context: context,
                ref: "ref\(index)",
                title: "title\(index)",
                isFavourite: index == 3
            )
            topics.append(topic)
        }
        return topics
    }

    @discardableResult
    static func arrange(context: NSManagedObjectContext,
                        ref: String = UUID().uuidString,
                        title: String = UUID().uuidString,
                        isFavourite: Bool = false) -> Topic {
        let topic = Topic(context: context)
        topic.ref = ref
        topic.title = title
        topic.isFavorite = isFavourite
        return topic
    }
}
