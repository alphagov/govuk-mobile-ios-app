import SwiftUI

struct NonTappableCardView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var text: String
    var body: some View {
        VStack {
            HStack {
                if verticalSizeClass != .compact {
                    Spacer()
                }
                Text(text)
                    .font(Font.govUK.body)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(
                        Color(UIColor.govUK.text.secondary)
                    )
                Spacer()
            }
        }.padding()
            .background(
                Color(uiColor: UIColor.govUK.fills.surfaceCardNonTappable)
            )
            .roundedBorder(borderColor: .clear)
           // .padding([.horizontal])
    }
}
