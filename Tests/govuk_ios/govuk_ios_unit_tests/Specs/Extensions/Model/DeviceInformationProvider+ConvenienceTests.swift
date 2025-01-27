import Foundation
import Testing

@testable import govuk_ios

struct DeviceInformationProvider_ConvenienceTests {

    @Test func helpAndFeedbackURL_returnsExpectedValue() async throws {
        let sut = MockDeviceInformationProvider(
            systemVersion: "18.2",
            model: "iPhone16"
            )
        var versionProvider = MockAppVersionProvider()
        versionProvider.versionNumber = "1.2.3"
        versionProvider.buildNumber = "456"


        let expectedURL = try #require(
            URL(
            string:"""
                   https://www.gov.uk/contact/govuk-app?app_version=1.2.3%20(456)&phone=Apple%20iPhone16%2018.2
                   """
            )?.absoluteString
        )

        #expect(sut.helpAndFeedbackURL(versionProvider: versionProvider).absoluteString == expectedURL)
    }

}
