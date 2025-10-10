import Testing

@testable import govuk_ios

struct TopicListItemViewModelTests {

    @Test
    func topicInitializer_initializesValues() {
        let coreData = CoreDataRepository.arrange

        let topic = Topic(context: coreData.viewContext)
        topic.ref = "driving-transport"
        topic.title = "Title"

        var didTap = false
        let sut = TopicListItemViewModel(
            topic: topic,
            tapAction: {
                didTap = true
            },
            backgroundColor: .white
        )

        sut.tapAction()

        #expect(sut.title == "Title")
        #expect(sut.iconName == "driving")
        #expect(didTap)
        #expect(sut.backgroundColor == .white)
    }
}
