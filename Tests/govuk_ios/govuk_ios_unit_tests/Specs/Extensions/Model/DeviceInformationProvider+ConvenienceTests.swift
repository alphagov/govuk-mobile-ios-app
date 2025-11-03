import Foundation
import Testing

@testable import govuk_ios

struct DeviceInformationProvider_ConvenienceTests {

    @Test
    func helpAndFeedbackURL_returnsExpectedValue() throws {
        let sut = MockDeviceInformationProvider(
            systemVersion: "18.2",
            model: "iPhone16"
            )
        let versionProvider = MockAppVersionProvider()
        versionProvider.versionNumber = "1.2.3"
        versionProvider.buildNumber = "456"


        let expectedURL = try #require(
            URL(
            string:
            """
            https://www.gov.uk/contact/govuk-app?app_version=1.2.3%20(456)&phone=Apple%20iPhone16%2018.2
            """
            )?.absoluteString
        )

        let result = sut.helpAndFeedbackURL(
            versionProvider: versionProvider
        ).absoluteString

        #expect(result == expectedURL)
    }

    @Test
    func reportProblem_validWhatHappened_returnsExpectedValue() throws {
        let sut = MockDeviceInformationProvider(
            systemVersion: "18.2",
            model: "iPhone16"
        )
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = "1.2.3"
        mockVersionProvider.buildNumber = "456"


        let expectedURL = try #require(
            URL(
                string:
            """
            https://www.gov.uk/contact/govuk-app/report-problem?app_version=1.2.3%20(456)&phone=Apple%20iPhone16%2018.2&what_happened=test%20123
            """
            )?.absoluteString
        )

        let result = sut.reportProblem(
            versionProvider: mockVersionProvider,
            whatHappened: "test 123"
        ).absoluteString

        #expect(result == expectedURL)
    }

    @Test
    func reportProblem_emptyWhatHappened_returnsExpectedValue() throws {
        let sut = MockDeviceInformationProvider(
            systemVersion: "18.2",
            model: "iPhone16"
        )
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = "1.2.3"
        mockVersionProvider.buildNumber = "456"


        let expectedURL = try #require(
            URL(
                string:
            """
            https://www.gov.uk/contact/govuk-app/report-problem?app_version=1.2.3%20(456)&phone=Apple%20iPhone16%2018.2
            """
            )?.absoluteString
        )

        let result = sut.reportProblem(
            versionProvider: mockVersionProvider,
            whatHappened: ""
        ).absoluteString

        #expect(result == expectedURL)
    }

    @Test
    func reportProblem_noWhatHappened_returnsExpectedValue() throws {
        let sut = MockDeviceInformationProvider(
            systemVersion: "18.2",
            model: "iPhone16"
        )
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = "1.2.3"
        mockVersionProvider.buildNumber = "456"


        let expectedURL = try #require(
            URL(
                string:
            """
            https://www.gov.uk/contact/govuk-app/report-problem?app_version=1.2.3%20(456)&phone=Apple%20iPhone16%2018.2
            """
            )?.absoluteString
        )

        let result = sut.reportProblem(
            versionProvider: mockVersionProvider,
            whatHappened: nil
        ).absoluteString

        #expect(result == expectedURL)
    }
}
