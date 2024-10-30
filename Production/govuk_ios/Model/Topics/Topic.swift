import Foundation
import CoreData

@objc(Topic)
class Topic: NSManagedObject,
             Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Topic> {
        let request = NSFetchRequest<Topic>(entityName: "Topic")
        request.sortDescriptors = [
            NSSortDescriptor(
                keyPath: \Topic.title,
                ascending: true
            )
        ]
        return request
    }

    @NSManaged public var ref: String
    @NSManaged public var title: String
    @NSManaged public var topicDescription: String?
    @NSManaged public var isFavorite: Bool

    var iconName: String {
        switch self.ref {
        case "benefits":
            return "sterlingsign"
        case "business":
            return "briefcase.fill"
        case "care":
            return "heart.fill"
        case "driving-transport":
            return "car.fill"
        case "employment":
            return "list.clipboard.fill"
        case "health-disability":
            return "cross.fill"
        case "money-tax":
            return "chart.pie.fill"
        case "parenting-guardianship":
            return "figure.and.child.holdinghands"
        case "retirement":
            return "chair.lounge.fill"
        case "studying-training":
            return "book.fill"
        case "travel":
            return "airplane"
        default:
            return "star.fill"
        }
    }

    func update(item: TopicResponseItem) {
        self.ref = item.ref
        self.title = item.title
        self.topicDescription = item.description
    }
}

extension Topic: DisplayableTopic {}
