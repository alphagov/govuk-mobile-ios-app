import Testing
import UIKit

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
    func topic_iconImage_returnsCorrectValue(ref: String,
                                            icon: UIImage) {
        let coreData = CoreDataRepository.arrange
        
        let topic = Topic(context: coreData.viewContext)
        topic.ref = ref
        topic.title = "Title"

        #expect(topic.icon.pngData() == icon.pngData())
    }

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
            "driving",
            "employment",
            "benefits",
            "care",
            "business",
            "health",
            "money",
            "parenting",
            "retirement",
            "studying",
            "travel",
            "default"
        ]
    ))
    func topic_iconName_returnsCorrectValue(ref: String,
                                            iconName: String) {
        let coreData = CoreDataRepository.arrange

        let topic = Topic(context: coreData.viewContext)
        topic.ref = ref
        topic.title = "Title"

        #expect(topic.iconName == iconName)
    }

}
