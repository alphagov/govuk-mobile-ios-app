import Foundation

struct CentreCard {
    let primaryText: String?
    let secondaryText: String?

    init(primaryText: String? = nil,
         secondaryText: String? = nil) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
    }
}
