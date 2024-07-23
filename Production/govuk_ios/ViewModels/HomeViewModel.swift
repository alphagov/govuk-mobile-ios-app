import Foundation
import UIKit

struct HomeViewModel {
    let headerLogo: UIImage = UIImage(named: "logo")!
    let headerBorderColor: CGColor = UIColor.secondaryBorder.cgColor
    let backgroundColor: UIColor = UIColor.primaryBackground
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
