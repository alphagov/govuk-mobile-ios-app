import Foundation
import SwiftUI
import UIComponents

struct StoredLocalAuthorityCardView: View {
    let model: StoredLocalAuthorityCardModel
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let description = model.description {
                    Text(description)
                        .frame(maxHeight: .infinity)
                        .font(.govUK.body)
                        .foregroundColor(Color(uiColor: UIColor.govUK.text.secondary))
                }
                Text(model.name)
                    .frame(maxHeight: .infinity)
                    .font(.govUK.title2Bold)
                    .foregroundColor(Color(uiColor: UIColor.govUK.text.link))
                    .accessibilityAddTraits(.isLink)
                    .accessibilityHint(String.common.localized("openWebLinkHint"))
            }
            .padding()
            .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .background {
            Color(uiColor: UIColor.govUK.fills.surfaceList)
        }
        .roundedBorder(borderColor: .clear)
        .shadow(color: Color(
            uiColor: UIColor.govUK.strokes.cardDefault),
                radius: 0, x: 0, y: 3
        )
    }
}
