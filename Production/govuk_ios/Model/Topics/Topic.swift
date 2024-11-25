import Foundation
import CoreData
import UIKit

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
    @NSManaged public var isFavourite: Bool

    var iconName: String {""
    }

    var icon: UIImage {
        switch self.ref {
        case "benefits":
            return .topicBenefitsIcon
        case "business":
            return .topicBusinessIcon
        case "care":
            return .topicCareIcon
        case "driving-transport":
            return .topicDrivingIcon
        case "employment":
            return .topicEmploymentIcon
        case "health-disability":
            return .topicHealthIcon
        case "money-tax":
            return .topicMoneyIcon
        case "parenting-guardianship":
            return .topicParentingIcon
        case "retirement":
            return .topicRetirementIcon
        case "studying-training":
            return .topicStudyIcon
        case "travel-abroad":
            return .topicTravelIcon
        default:
            return .topicDefaultIcon
        }
    }


    func update(item: TopicResponseItem) {
        self.ref = item.ref
        self.title = item.title
        self.topicDescription = item.description
    }
}

extension Topic: DisplayableTopic {}
