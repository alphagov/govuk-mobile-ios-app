import SwiftUI

struct TopicCardViewSwiftUI: View {
    let model: Topic
    @ScaledMetric var scale: CGFloat = 1
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Image(uiImage: model.icon)
                        .padding([.top], 2)
                }
                Spacer()
                HStack {
                    Text(model.title)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12 * scale, height: 12 * scale)
                }.padding([.bottom], 10)
            }.padding()
        }


        let image = UIImage(systemName: "chevron.forward")
        let config = UIImage.SymbolConfiguration(pointSize: 12)
//        .overlay(
//            RoundedRectangle(cornerRadius: 16)
//                .stroke(.red, lineWidth: 1)
//        )
//        .background {
//            Color.teal.opacity(0.3)
//                .ignoresSafeArea()
//        }.cornerRadius(8)
//            .stroke
    }
}
