import SwiftUI
import UIComponents

struct ChatWidgetView: View {
    let viewModel: ChatWidgetViewModel

    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.title)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .font(Font.govUK.bodySemibold)
                    .multilineTextAlignment(.leading)
                    .padding(.top)
                    .padding(.bottom, 10)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilitySortPriority(3)
                Text(viewModel.body)
                    .font(Font.govUK.body)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .multilineTextAlignment(.leading)
                    .accessibilitySortPriority(2)
                Button {
                    viewModel.open()
                } label: {
                    Text(viewModel.linkTitle)
                        .font(Font.govUK.body)
                        .foregroundColor(Color(UIColor.govUK.text.link))
                        .multilineTextAlignment(.leading)
                        .accessibilityAddTraits(.isLink)
                        .accessibilitySortPriority(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 10)
                        .padding(.bottom)
                }
            }
            .padding(.leading)
            .padding(.trailing, 4)
            Spacer()
            ZStack(alignment: .trailing) {
                VStack(spacing: 0) {
                    Spacer()
                    Image(decorative: "chat_onboarding_info")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 69)
                        .padding(.trailing, verticalSizeClass == .compact ? 55 : 16)
                    Spacer()
                }
                VStack(spacing: 0) {
                    Button {
                        viewModel.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(UIColor.govUK.text.secondary))
                            .frame(width: 44, height: 44)
                            .accessibilitySortPriority(0)
                    }
                    .accessibilityLabel(
                        String.chat.localized("dismissChatBannerAccessibilityLabel")
                    )
                    Spacer()
                }
            }
        }.frame(maxWidth: .infinity)
            .background(Image(decorative: verticalSizeClass == .compact ?
                              "chat_card_landscape" : "chat_card_portrait")
                .resizable()
            )
            .roundedBorder(borderColor: .clear)
            .shadow(color: Color(uiColor: UIColor.govUK.strokes.cardDefault),
                    radius: 0, x: 0, y: 3
            )
            .padding(.bottom, 3)
    }
}
