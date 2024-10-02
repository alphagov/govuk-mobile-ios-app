import Foundation
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct HomeViewModelTests {
    @Test
    func widgets_returnsArrayOfWidgets() {
        let subject = HomeViewModel(
            configService: MockAppConfigService(),
            topicsService: MockTopicsService(),
            searchButtonPrimaryAction: { },
            recentActivityAction: {},
            topicAction: { _ in }
        )
        let widgets = subject.widgets

        #expect((widgets as Any) is [WidgetView])
        #expect(widgets.count == 2)
    }

    @Test
    func widgets_featureDisabled_doesntReturnWidget() {
        let configService = MockAppConfigService()
        configService.features = []

        let subject = HomeViewModel(
            configService: configService,
            topicsService: MockTopicsService(),
            searchButtonPrimaryAction: { },
            recentActivityAction: {},
            topicAction: { _ in }
        )
        let widgets = subject.widgets

        #expect(widgets.count == 1)
    }
}
