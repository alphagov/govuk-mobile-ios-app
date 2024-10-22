import Foundation
import Testing

@testable import govuk_ios

@Suite
struct TopicDetailResponseTests {

    @Test
    func popularContent_empty_returnsNil() {
        let sut = TopicDetailResponse(
            content: [
                .init(
                    description: "",
                    isStepByStep: true,
                    popular: false,
                    title: "test_title",
                    url: .init(string: "www.test.com")!
                )
            ],
            ref: "1234",
            subtopics: [],
            title: "title"
        )
        #expect(sut.popularContent == nil)
    }

    @Test
    func stepByStepContent_empty_returnsNil() {
        let sut = TopicDetailResponse(
            content: [],
            ref: "1234",
            subtopics: [],
            title: "title"
        )
        #expect(sut.stepByStepContent == nil)
    }

    @Test
    func otherContent_empty_returnsNil() {
        let sut = TopicDetailResponse(
            content: [],
            ref: "1234",
            subtopics: [],
            title: "title"
        )
        #expect(sut.otherContent == nil)
    }

    @Test
    func popularContent_some_returnsNil() {
        let sut = TopicDetailResponse(
            content: [
                .init(
                    description: "",
                    isStepByStep: false,
                    popular: true,
                    title: "test_title",
                    url: .init(string: "www.test.com")!
                )
            ],
            ref: "1234",
            subtopics: [],
            title: "title"
        )
        #expect(sut.popularContent?.count == 1)
        #expect(sut.popularContent?.first?.title == "test_title")
    }

    @Test
    func stepByStepContent_some_returnsNil() {
        let sut = TopicDetailResponse(
            content: [
                .init(
                    description: "",
                    isStepByStep: true,
                    popular: false,
                    title: "test_title",
                    url: .init(string: "www.test.com")!
                )
            ],
            ref: "1234",
            subtopics: [],
            title: "title"
        )
        #expect(sut.stepByStepContent?.count == 1)
        #expect(sut.stepByStepContent?.first?.title == "test_title")
    }

    @Test
    func otherContent_some_returnsNil() {
        let sut = TopicDetailResponse(
            content: [
                .init(
                    description: "",
                    isStepByStep: false,
                    popular: false,
                    title: "test_title",
                    url: .init(string: "www.test.com")!
                )
            ],
            ref: "1234",
            subtopics: [],
            title: "title"
        )
        #expect(sut.otherContent?.count == 1)
        #expect(sut.otherContent?.first?.title == "test_title")
    }

}
