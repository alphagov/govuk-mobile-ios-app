import Foundation
import SwiftUI

struct AltGroupedListSection {
    let heading: AdaptiveListRow
    let rows: [AdaptiveListRow]
    let footer: String?

    init(heading: AdaptiveListRow,
         rows: [AdaptiveListRow],
         footer: String?) {
        self.heading = heading
        self.rows = rows
        self.footer = footer
    }
}
