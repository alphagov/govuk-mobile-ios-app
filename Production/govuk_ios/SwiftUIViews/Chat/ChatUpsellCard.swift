import SwiftUI
import UIComponents

struct ChatUpsellCard: View {
    let dismissAction: () -> Void
    let linkAction: () -> Void
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(String.chat.localized("upsellCardTitle"))
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                            .font(Font.govUK.bodySemibold)
                        Text(String.chat.localized("upsellCardDescription"))
                            .font(Font.govUK.body)
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                        Button {
                            linkAction()
                        } label: {
                            Text(String.chat.localized("upsellCardLinkText"))
                                .font(Font.govUK.body)
                                .foregroundColor(Color(UIColor.govUK.text.link))
                        }
                    }
                    .padding(.trailing, 4)
                    VStack {
                       Spacer()
                        Image(decorative: "chat_onboarding_info")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 69)
                        Spacer()
                    }
                    VStack {
                        Button(action: {
                            dismissAction()
                        }, label: {
                            VStack {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color(UIColor.govUK.text.secondary))
                            }
                        })
                        .accessibilityLabel(
                            String.chat.localized("upsellCardDismissButtonLabel")
                        )
                    }
                }.padding()
            }
            .background(Image(decorative: verticalSizeClass == .compact ?
                              "chat_card_landscape" : "chat_card_portrait")
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
