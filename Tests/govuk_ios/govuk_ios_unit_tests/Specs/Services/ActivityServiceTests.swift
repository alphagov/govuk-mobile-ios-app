import Foundation
import Testing

@testable import govuk_ios

@Suite
struct ActivityServiceTests {

    @Test
    func save_savesItem() throws {
        let mockRepository = MockActivityRepository()
        let sut = ActivityService(
            repository: mockRepository
        )
        let expectedItem = SearchItem(
            title: "test_title",
            description: "test_description",
            link: "test_link"
        )
        sut.save(searchItem: expectedItem)

        let receivedParams = mockRepository._receivedSaveParams
        #expect(receivedParams?.id == "test_link")
        #expect(receivedParams?.title == "test_title")
        #expect(receivedParams?.url == "test_link")
        let receivedDate = try #require(receivedParams?.date)
        let calendar = Calendar.current
        let equalDates = calendar.isDate(
            receivedDate,
            equalTo: .init(),
            toGranularity: .second
        )
        #expect(equalDates)
    }

}
