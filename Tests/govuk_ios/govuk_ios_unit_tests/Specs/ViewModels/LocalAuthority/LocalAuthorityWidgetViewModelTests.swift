import Foundation
import Testing

@testable import govuk_ios

struct LocalAuthorityWidgetViewModelTests {

    @Test
    func title_returnsCorrectValue() throws {
        let sut = LocalAuthorityWidgetViewModel(
            tapAction: {}
        )
        let title = String.localAuthority.localized(
            "localServicesTitle"
        )
        #expect(sut.title == title)
    }

    @Test
    func description_returnsCorrectValue() throws {
        let sut = LocalAuthorityWidgetViewModel(
            tapAction: {}
        )
        let description = String.localAuthority.localized(
            "localAuthorityWidgetViewDescription"
        )
        #expect(sut.description == description)
    }
}
