import Foundation
import SwiftUI

struct AltGroupedListSection {
    let heading: AdaptiveListRow
    let rows: [AdaptiveListRow]
    let footer: String?

    init(heading: any View,
         rows: [AdaptiveListRow],
         footer: String?) {
        self.heading = .init(view: heading)
        self.rows = rows
        self.footer = footer
    }
}
