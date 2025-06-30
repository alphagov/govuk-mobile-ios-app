import Foundation
import SwiftUI

struct StoredLocalAuthorityCardView: View {
    let model: StoredLocalAuthorityCardModel
    var body: some View {
        ZStack {
            Color(uiColor: UIColor.govUK.fills.surfaceCardBlue)
            VStack {
                HStack {
                    Text(model.name)
                        .font(.govUK.body)
                        .foregroundColor(Color(UIColor.govUK.text.link))
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(Color(UIColor.govUK.text.link))
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(model.name)
                .accessibilityAddTraits(.isLink)
                .accessibilityHint(String.common.localized("openWebLinkHint"))
                .padding(.bottom, 4)
                HStack {
                    Text(model.description)
                        .font(.govUK.body)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            .padding()
        }
        .roundedBorder()
    }
}
