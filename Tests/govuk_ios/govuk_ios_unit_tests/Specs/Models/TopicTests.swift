import Testing

@testable import govuk_ios

@Suite
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
    ))
    func topic_iconName_returnsCorrectValue(ref: String, iconName: String) {
        let coreData = CoreDataRepository.arrange
        
        let topic = Topic(context: coreData.viewContext)
        topic.ref = ref
        topic.title = "Title"
        #expect(topic.iconName == iconName)
    }

}
