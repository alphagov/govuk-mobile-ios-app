import SwiftUI

struct TopicCard: View {
    let model: Topic
    @ScaledMetric var scale: CGFloat = 1
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Image(uiImage: model.icon)
                    .foregroundColor(Color(uiColor: UIColor.govUK.text.trailingIcon))
                    .padding([.top], 2)
                Spacer()
                HStack(alignment: .bottom) {
                    Text(model.title)
                        .font(Font.govUK.bodySemibold)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(uiColor: UIColor.govUK.text.trailingIcon))
                        .frame(width: 12 * scale, height: 12 * scale)
                        .padding([.bottom], 3)
                }
            }.padding()
        }.accessibilityAddTraits(.isButton)
    }
}
