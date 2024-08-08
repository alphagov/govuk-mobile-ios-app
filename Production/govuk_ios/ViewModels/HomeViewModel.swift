import Foundation
import UIKit

struct HomeViewModel {
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
}
