import SwiftUI
import UIComponents

struct ChatCard: View {
    let model: ChatCardModel
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                        Text(model.title)
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                            .font(Font.govUK.bodySemibold)

                        Text(model.primaryDescritpion)
                            .font(Font.govUK.body)
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                    Text(model.secondaryDescription)
                        .foregroundColor(Color(UIColor.govUK.text.secondary))
                        .font(Font.govUK.body)
                    Text(model.link)
                        .font(Font.govUK.body)
                        .foregroundColor(Color(UIColor.govUK.text.link))
                }
                Spacer()
                VStack(spacing: 6) {
                        Button(action: {
                            model.action()
                        }, label: {
                            VStack {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color(UIColor.govUK.text.secondary))
                            }
                        }).frame(alignment: .leading)
                        .padding(.leading)
                    Image(model.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 69)
                        .padding(.bottom)
//                    .frame(alignment: .topLeading)
//                    Spacer()
                }
  //                      .overlay(alignment: .topTrailing) {
//                    Button(action: {
//                        model.action()
//                    }, label: {
//                        VStack {
//                            Image(systemName: "xmark")
//                                .foregroundColor(Color(UIColor.govUK.text.secondary))
//                        }.padding()
//                    })
//                }
            }.padding()
        }
        .background(Color(uiColor: UIColor.govUK.fills.surfaceBackground))
        .roundedBorder(borderColor: .clear)
        .shadow(color: Color(uiColor: UIColor.green), radius: 0, x: 0, y: 3)
        .padding()
    }
}

struct ChatCardModel {
    let action: () -> Void
    let image: String
    let title: String
    let primaryDescritpion: String
    let secondaryDescription: String
    let link: String
}

#Preview {
    let model = ChatCardModel(
        action: {},
        image: "chat_onboarding_info",
        title: "title",
        primaryDescritpion: "description",
        secondaryDescription: " second description",
        link: "ask a question"
    )
    ChatCard(model: model)
}
