import Foundation
import Testing

@testable import govuk_ios


@Suite
struct ActivityItemCreateParamsTests {
    @Test
    func init_searchItem_setsExpectedProperties() {
        let result = ActivityItemCreateParams(
            searchItem: .init(
                title: "test_test",
                description: "test_description",
                contentId: UUID().uuidString,
                link: URL(string: "www.test.com")!
            )
        )
        #expect(result.id == "www.test.com")
        #expect(result.title == "test_test")
        #expect(result.url == "www.test.com")
    }

    @Test
    func init_topicContent_setsExpectedProperties() {
        let result = ActivityItemCreateParams(
            topicContent: .init(
                title: "test_test",
                description: "",
                isStepByStep: false,
                popular: true,
                url: URL(string: "www.test.com")!
            )
        )
        #expect(result.id == "www.test.com")
        #expect(result.title == "test_test")
        #expect(result.url == "www.test.com")
    }

}
