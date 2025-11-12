import SwiftUI
import UIComponents

struct NonTappableCardView: View {
    var text: String
    var body: some View {
        VStack {
            HStack {
                Text(text)
                    .font(Font.govUK.body)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(
                        Color(UIColor.govUK.text.secondary)
                    )
                Spacer()
            }.padding()
        }
        .background(
                Color(uiColor: UIColor.govUK.fills.surfaceCardNonTappable)
            )
            .roundedBorder(borderColor: .clear)
    }
}
