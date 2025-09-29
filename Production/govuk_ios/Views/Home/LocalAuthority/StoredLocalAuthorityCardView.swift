import Foundation
import SwiftUI

struct StoredLocalAuthorityCardView: View {
    let model: StoredLocalAuthorityCardModel
    var body: some View {
            VStack {
                Text(model.description)
                Text(model.name)
            }
            .roundedBorder()
            .accessibilityElement(children: .combine)
            .accessibilityLabel(model.name)
            .accessibilityAddTraits(.isLink)
            .accessibilityHint(String.common.localized("openWebLinkHint"))
        }
    }
