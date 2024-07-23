import Foundation
import UIKit

struct HomeViewModel {
    let headerLogo: UIImage
    let headerBorderColor: CGColor
    let backgroundColor: UIColor
    var sections: [HomeSectionViewModel] {
        [
            HomeSectionViewModel(
                title: "Scrollable Content",
                link: ["text": "Link text same blue as logo", "link": ""]
            ),
            HomeSectionViewModel(title: "Scrollable Content"),
            HomeSectionViewModel(title: "Scrollable Content"),
            HomeSectionViewModel(title: "Scrollable Content"),
            HomeSectionViewModel(title: "Scrollable Content"),
            HomeSectionViewModel(title: "Scrollable Content")
        ]
    }
}
