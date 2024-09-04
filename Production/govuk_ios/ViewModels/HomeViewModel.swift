import Foundation
import UIKit

struct HomeViewModel {
    @Inject(\.activityService) private var activityService: ActivityServiceInterface

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
}
