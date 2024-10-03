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
        let expectedTitle = UUID().uuidString
        let expectedURLString = "https://www.govuk.com/test"
        let expectedItem = SearchItem(
            title: expectedTitle,
            description: "test_description",
            link: URL(string: "https://www.govuk.com/test")!
        )
        sut.save(searchItem: expectedItem)

        let receivedParams = mockRepository._receivedSaveParams
        #expect(receivedParams?.id == expectedURLString)
        #expect(receivedParams?.title == expectedTitle)
        #expect(receivedParams?.url == expectedURLString)
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
