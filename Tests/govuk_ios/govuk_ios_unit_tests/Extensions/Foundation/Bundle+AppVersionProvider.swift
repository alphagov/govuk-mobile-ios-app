import Foundation
import Testing

@testable import govuk_ios

@Suite
struct Bundle_AppVersionProviderTests {
    @Test
    func versionNumber_returnsExpectedValue() {
        #expect(Bundle.main.versionNumber == Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)
    }

    @Test
    func buildNumber_returnsExpectedValue() {
        #expect(Bundle.main.buildNumber == Bundle.main.infoDictionary?["CFBundleVersion"] as? String)
    }

    @Test
    func fullBuildNumber_returnsExpectedValue() throws {
        let version = try #require(Bundle.main.versionNumber)
        let build = try #require(Bundle.main.buildNumber)
        #expect(Bundle.main.fullBuildNumber == "\(version) (\(build))")
    }
}
