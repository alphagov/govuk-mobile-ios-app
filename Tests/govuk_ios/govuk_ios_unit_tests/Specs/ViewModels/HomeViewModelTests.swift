import Foundation
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct HomeViewModelTests {
    @Test
    func widgets_returnsArrayOfWidgets() {
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            topicAction: { _ in },
            editAction: { _ in }
        )
        let subject = HomeViewModel(
            configService: MockAppConfigService(),
            searchButtonPrimaryAction: { () -> Void in _ = true },
            recentActivityAction: { },
            topicWidgetViewModel: topicsViewModel
        )
        let widgets = subject.widgets

        #expect((widgets as Any) is [WidgetView])
        #expect(widgets.count == 3)
    }

    @Test
    func widgets_featureDisabled_doesntReturnWidget() {
        let configService = MockAppConfigService()
        configService.features = []

        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            topicAction: { _ in },
            editAction: { _ in }
        )
        let subject = HomeViewModel(
            configService: configService,
            searchButtonPrimaryAction: { },
            recentActivityAction: { },
            topicWidgetViewModel: topicsViewModel
        )
        let widgets = subject.widgets

        #expect(widgets.count == 1)
    }
}
