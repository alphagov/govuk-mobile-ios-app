import Foundation
import UIKit

struct HomeViewModel {
    var analyticsService: AnalyticsServiceInterface
    var widgets: [HomeWidgetViewModel] {
        [
            HomeWidgetViewModel(
                title: "Scrollable Content",
                link: ["text": "Link text same blue as logo", "link": ""]
            ),
            HomeWidgetViewModel(title: "Scrollable Content"),
            HomeWidgetViewModel(title: "Scrollable Content"),
            HomeWidgetViewModel(title: "Scrollable Content"),
            HomeWidgetViewModel(title: "Scrollable Content"),
            HomeWidgetViewModel(title: "Scrollable Content")
        ]
    }

    func logScreen() {
        let screen = HomeScreen(name: "homescreen")
        analyticsService.trackScreen(screen)
    }
}
