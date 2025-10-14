import Testing
import SwiftUI

@testable import govuk_ios

@Suite
struct TopicSelectionCardViewModelTests {
    let coreData = CoreDataRepository.arrangeAndLoad.backgroundContext

    @Test
    func isOn_update_callsTapAction() async {
        await confirmation() { confirmation in
            let topic = Topic(context: coreData)
            let sut = TopicSelectionCardViewModel(
                topic: topic,
                tapAction: { _ in confirmation() }
            )
            sut.isOn.toggle()
        }
    }

    @Test
    func title_returnsTitle() {
        let topic = Topic(context: coreData)
        topic.title = "Test title"
        let sut = TopicSelectionCardViewModel(
            topic: topic,
            tapAction: { _ in }
        )
        #expect(sut.title == "Test title")
    }

    @Test
    func iconName_returnsCorrectIconName() {
        let topic = Topic(context: coreData)
        topic.ref = "business"
        let sut = TopicSelectionCardViewModel(
            topic: topic,
            tapAction: { _ in }
        )
        #expect(sut.iconName == "business")
    }

    @Test
    func iconName_favourite_returnsCorrectIconName() {
        let topic = Topic(context: coreData)
        topic.ref = "business"
        topic.isFavourite = true
        let sut = TopicSelectionCardViewModel(
            topic: topic,
            tapAction: { _ in }
        )
        #expect(sut.iconName == "topic_selected")
    }

    @Test
    func backgroundColor_returnsCorrectColor() {
        let topic = Topic(context: coreData)
        topic.isFavourite = false
        let sut = TopicSelectionCardViewModel(
            topic: topic,
            tapAction: { _ in }
        )
        #expect(sut.backgroundColor == .govUK.fills.surfaceListUnselected)
    }

    @Test
    func backgroundColor_favourite_returnsCorrectColor() {
        let topic = Topic(context: coreData)
        topic.isFavourite = true
        let sut = TopicSelectionCardViewModel(
            topic: topic,
            tapAction: { _ in }
        )
        #expect(sut.backgroundColor == .govUK.fills.surfaceListSelected)
    }

    @Test
    func titleColor_returnsCorrectColor() {
        let topic = Topic(context: coreData)
        topic.isFavourite = false
        let sut = TopicSelectionCardViewModel(
            topic: topic,
            tapAction: { _ in }
        )
        #expect(sut.titleColor == .govUK.text.listUnselected)
    }

    @Test
    func titleColor_favourite_returnsCorrectColor() {
        let topic = Topic(context: coreData)
        topic.isFavourite = true
        let sut = TopicSelectionCardViewModel(
            topic: topic,
            tapAction: { _ in }
        )
        #expect(sut.titleColor == .govUK.text.listSelected)
    }

    @Test
    func accessibilityHint_returnsCorrectHint() {
        let topic = Topic(context: coreData)
        topic.isFavourite = false
        let sut = TopicSelectionCardViewModel(
            topic: topic,
            tapAction: { _ in }
        )
        #expect(sut.accessibilityHint == "Unselected")
    }

    @Test
    func accessibilityHint_favourite_returnsCorrectHint() {
        let topic = Topic(context: coreData)
        topic.isFavourite = true
        let sut = TopicSelectionCardViewModel(
            topic: topic,
            tapAction: { _ in }
        )
        #expect(sut.accessibilityHint == "Selected")
    }
}
