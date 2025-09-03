import SwiftUI
import UIComponents

struct ChatCard: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    let action: () -> Void
    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                        Text(String.chat.localized("cardTitle"))
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                            .font(Font.govUK.bodySemibold)
                        Text(String.chat.localized("cardDescription"))
                            .font(Font.govUK.body)
                            .foregroundColor(Color(UIColor.govUK.text.secondary))
                    Text(String.chat.localized("cardLinkText"))
                        .font(Font.govUK.body)
                        .foregroundColor(Color(UIColor.govUK.text.link))
                }
                Spacer(minLength: 18)
                VStack {
                        Button(action: {
                            action()
                        }, label: {
                            VStack {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color(UIColor.govUK.text.secondary))
                            }
                        }).frame(alignment: .trailing)
                        .padding(.leading, 38)
                        .padding(.bottom)
                        Image("chat_onboarding_info")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 69)
                            .frame(alignment: .leading)
                            .padding(
                                .trailing, verticalSizeClass == .compact ? 32 : 4
                            )
                }
            }.padding()
        }
        .background(Color(uiColor: UIColor.govUK.fills.surfaceBackground))
        .roundedBorder(borderColor: .clear)
        .shadow(color: Color(uiColor: UIColor.green), radius: 0, x: 0, y: 3)
        .padding()
    }
}
