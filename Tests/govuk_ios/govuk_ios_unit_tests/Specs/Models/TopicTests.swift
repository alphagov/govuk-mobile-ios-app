import Testing
import UIKit
import GOVKit
@testable import govuk_ios

@Suite
@MainActor
struct TopicTests {

    @Test(arguments: zip(
        [
            "driving-transport",
            "employment",
            "benefits",
            "care",
            "business",
            "health-disability",
            "money-tax",
            "parenting-guardianship",
            "retirement",
            "studying-training",
            "travel-abroad",
            "unknown"
        ],
        [
            UIImage.topicDrivingIcon,
            UIImage.topicEmploymentIcon,
            UIImage.topicBenefitsIcon,
            UIImage.topicCareIcon,
            UIImage.topicBusinessIcon,
            UIImage.topicHealthIcon,
            UIImage.topicMoneyIcon,
            UIImage.topicParentingIcon,
            UIImage.topicRetirementIcon,
            UIImage.topicStudyIcon,
            UIImage.topicTravelIcon,
            UIImage.topicDefaultIcon,
        ]
    ))
    func topic_iconName_returnsCorrectValue(ref: String,
                                            icon: UIImage) {
        let coreData = CoreDataRepository.arrange
        
        let topic = Topic(context: coreData.viewContext)
        topic.ref = ref
        topic.title = "Title"

        #expect(topic.icon.pngData() == icon.pngData())
    }
}
