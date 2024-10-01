import Testing

@testable import govuk_ios

@Suite
struct TopicTests {

    @Test(arguments: zip(
        [
            "driving-transport",
            "benefits",
            "care",
            "parenting",
            "business",
            "unknown"
        ],
        [
            "car.fill",
            "sterlingsign",
            "heart.fill",
            "figure.and.child.holdinghands",
            "briefcase.fill",
            "star.fill"
        ]
    ))
    func topic_iconName_returnsCorrectValue(ref: String, iconName: String) {
        let topic = Topic(ref: ref, title: "Title")
        #expect(topic.iconName == iconName)
    }

}
