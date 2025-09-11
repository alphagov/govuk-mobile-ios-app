import SwiftUI

struct NonTappableCardView: View {
    var text: String
    var body: some View {
        VStack {
            Text(text)
                .font(Font.govUK.body)
                .multilineTextAlignment(.leading)
                .foregroundColor(
                    Color(UIColor.govUK.text.secondary)
                )
        }.padding()
            .background(
                Color(uiColor: UIColor.govUK.fills.surfaceCardNonTappable)
            )
            .roundedBorder(borderColor: .clear)
            .padding()
    }
}
