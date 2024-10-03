import XCTest

@testable import govuk_ios

final class TopicsTestsXC: XCTestCase {


    func test_topic_iconName_returnsCorrectValue() {
        let iconMapping = zip(
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
                "travel",
                "unknown"
            ],
            [
                "car.fill",
                "list.clipboard.fill",
                "sterlingsign",
                "heart.fill",
                "briefcase.fill",
                "cross.fill",
                "chart.pie.fill",
                "figure.and.child.holdinghands",
                "chair.lounge.fill",
                "book.fill",
                "airplane",
                "star.fill"
            ]
        )
        iconMapping.forEach { (ref, iconName) in
            let topic = Topic(ref: ref, title: "Title")
            XCTAssertEqual(topic.iconName, iconName)
        }
    }

}
