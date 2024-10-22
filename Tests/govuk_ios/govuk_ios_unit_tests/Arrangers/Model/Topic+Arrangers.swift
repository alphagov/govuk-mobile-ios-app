import Foundation
import CoreData

@testable import govuk_ios

extension Topic {
    @discardableResult
    static func arrange(context: NSManagedObjectContext) -> [Topic] {
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
