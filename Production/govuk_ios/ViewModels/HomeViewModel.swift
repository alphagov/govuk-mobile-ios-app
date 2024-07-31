import Foundation
import UIKit

struct HomeViewModel {
    var analyticsService: AnalyticsServiceInterface
    var sections: [HomeWidgetViewModel] {
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
        let screen = HomeScreen(name: "homepage")
        analyticsService.trackScreen(screen)
    }
}
