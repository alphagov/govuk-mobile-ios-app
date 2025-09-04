import SwiftUI
import UIComponents

struct ChatUpsellCard: View {
    let action: () -> Void
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                HStack(alignment: .top, spacing: 4) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String.chat.localized("upsellCardTitle"))
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                            .font(Font.govUK.bodySemibold)
                        Text(String.chat.localized("upsellCardDescription"))
                            .font(Font.govUK.body)
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                        Text(String.chat.localized("upsellCardLinkText"))
                            .font(Font.govUK.body)
                            .foregroundColor(Color(UIColor.govUK.text.link))
                    }
                    .padding(.trailing, 16)
                    VStack {
                       Spacer()
                        Image(decorative: "chat_onboarding_info")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 69)
                        Spacer()
                    }
                   // .padding(.bottom, returnImagePadding())
                    VStack {
                        Button(action: {
                            action()
                        }, label: {
                            VStack {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color(UIColor.govUK.text.secondary))
                            }
                        })
                        .accessibilityLabel(
                            String.chat.localized("upsellCardDismissButtonLabel")
                        )
                        .frame(alignment: .trailing)
                    }
                }.padding()
            }
            .background(Image(decorative: "chat_card_gradient")
                .resizable()
            )
            .roundedBorder(borderColor: .clear)
            .shadow(color: Color(uiColor: UIColor.govUK.strokes.cardDefault),
                    radius: 0, x: 0, y: 3
            )
            .padding()
       }
    }
}
