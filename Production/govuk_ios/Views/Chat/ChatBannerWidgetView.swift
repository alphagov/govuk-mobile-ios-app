import SwiftUI
import UIComponents

struct ChatBannerWidgetView: View {
    let viewModel: ChatBannerWidgetViewModel

    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        Button {
            viewModel.open()
        } label: {
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(viewModel.title)
                                .foregroundColor(Color(UIColor.govUK.text.primary))
                                .font(Font.govUK.bodySemibold)
                                .multilineTextAlignment(.leading)
                            Text(viewModel.body)
                                .font(Font.govUK.body)
                                .foregroundColor(Color(UIColor.govUK.text.primary))
                                .multilineTextAlignment(.leading)
                            Text(viewModel.linkTitle)
                                .font(Font.govUK.body)
                                .foregroundColor(Color(UIColor.govUK.text.link))
                                .multilineTextAlignment(.leading)
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
                                viewModel.dismiss()
                            }, label: {
                                VStack {
                                    Image(systemName: "xmark")
                                        .foregroundColor(Color(UIColor.govUK.text.secondary))
                                }
                            })
                            .accessibilityLabel(
                                String.chat.localized("dismissChatBannerAccessibilityLabel")
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
                .padding(.bottom, 3)
            }
        }
    }
}
