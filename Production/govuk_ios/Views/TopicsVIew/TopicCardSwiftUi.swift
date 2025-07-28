import SwiftUI

struct TopicCardSwiftUI: View {
    let model: Topic
    @ScaledMetric var scale: CGFloat = 1
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Image(uiImage: model.icon)
                        .tint(Color(uiColor: UIColor.govUK.text.trailingIcon))
                        .padding([.top], 2)
                }
                Spacer()
                HStack {
                    Text(model.title)
                        .font(Font.govUK.bodySemibold)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .scaledToFit()
                        .tint(Color(uiColor: UIColor.govUK.text.trailingIcon))
                        .frame(width: 12 * scale, height: 12 * scale)
                }.padding([.bottom], 10)
            }.padding()
        }.accessibilityAddTraits(.isButton)
    }
}
