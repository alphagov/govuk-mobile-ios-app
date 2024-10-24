import Testing

@testable import govuk_ios

struct StepByStepsViewModelTests {

    let mockTopicsService = MockTopicsService()
    let mockAnalyticsService = MockAnalyticsService()
    let mockActivityService = MockActivityService()
    let mockURLOpener = MockURLOpener()

    @Test
    func init_hasCorrectParameters() {
        let sut = StepByStepsViewModel(
            content: [],
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener
        )
        #expect(sut.title == "Step by step guides")
        #expect(sut.description == nil)
        #expect(sut.sections.count == 1)
    }
}
