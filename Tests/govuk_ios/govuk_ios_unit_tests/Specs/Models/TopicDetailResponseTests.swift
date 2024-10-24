import Foundation
import Testing

@testable import govuk_ios

@Suite
struct TopicDetailResponseTests {

    @Test
    func popularContent_empty_returnsNil() {
        let sut = TopicDetailResponse(
            ref: "1234",
            title: "title",
            description: "description",
            content: [
                .init(
                    title: "test_title",
                    description: "",
                    isStepByStep: true,
                    popular: false,
                    url: .init(string: "www.test.com")!
                )
            ],
            subtopics: []
        )
        #expect(sut.popularContent == nil)
    }

    @Test
    func stepByStepContent_empty_returnsNil() {
        let sut = TopicDetailResponse(
            ref: "1234",
            title: "title",
            description: "description",
            content: [],
            subtopics: []
        )
        #expect(sut.stepByStepContent == nil)
    }

    @Test
    func otherContent_empty_returnsNil() {
        let sut = TopicDetailResponse(
            ref: "1234",
            title: "title",
            description: "description",
            content: [],
            subtopics: []
        )
        #expect(sut.otherContent == nil)
    }

    @Test
    func popularContent_some_returnsExpectedContent() {
        let sut = TopicDetailResponse(
            ref: "1234",
            title: "title",
            description: "description",
            content: [
                .init(
                    title: "test_title",
                    description: "",
                    isStepByStep: false,
                    popular: true,
                    url: .init(string: "www.test.com")!
                )
            ],
            subtopics: []
        )
        #expect(sut.popularContent?.count == 1)
        #expect(sut.popularContent?.first?.title == "test_title")
    }

    @Test
    func stepByStepContent_some_returnsExpectedContent() {
        let sut = TopicDetailResponse(
            ref: "1234",
            title: "title",
            description: "description",
            content: [
                .init(
                    title: "test_title",
                    description: "",
                    isStepByStep: true,
                    popular: false,
                    url: .init(string: "www.test.com")!
                )
            ],
            subtopics: []
        )
        #expect(sut.stepByStepContent?.count == 1)
        #expect(sut.stepByStepContent?.first?.title == "test_title")
    }

    @Test
    func otherContent_some_returnsExpectedContent() {
        let sut = TopicDetailResponse(
            ref: "1234",
            title: "title",
            description: "description",
            content: [
                .init(
                    title: "test_title",
                    description: "",
                    isStepByStep: false,
                    popular: false,
                    url: .init(string: "www.test.com")!
                )
            ],
            subtopics: []
        )
        #expect(sut.otherContent?.count == 1)
        #expect(sut.otherContent?.first?.title == "test_title")
    }

}
