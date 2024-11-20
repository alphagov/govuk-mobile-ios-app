import Testing
@testable import govuk_ios

@Suite
struct AppEnvironmentServiceTests {

    @Test
    func appEnvironmentService_returnsExpectedValueForBaseURL() async throws {
        let mockConfig = ["BaseURL": "https://www.example.com"]
        let sut = AppEnvironmentService(config: mockConfig)
        
        #expect(sut.baseURL.absoluteString == "https://www.example.com")
    }
}
