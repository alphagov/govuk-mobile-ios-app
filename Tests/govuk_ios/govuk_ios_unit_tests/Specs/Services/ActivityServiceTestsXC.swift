import Foundation
import XCTest

@testable import govuk_ios

final class ActivityServiceTestsXC: XCTestCase {
    func test_save_savesItem() throws {
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
        XCTAssertEqual(receivedParams?.id, "test_link")
        XCTAssertEqual(receivedParams?.title, "test_title")
        XCTAssertEqual(receivedParams?.url, "test_link")
        let receivedDate = try XCTUnwrap(receivedParams?.date)
        let calendar = Calendar.current
        let equalDates = calendar.isDate(
            receivedDate,
            equalTo: .init(),
            toGranularity: .second
        )
        XCTAssertTrue(equalDates)
    }

}
