import SwiftUI
import GOVKit
import UIComponents

struct TopicListItemView: View {
    private var viewModel: TopicCardModel
    init(viewModel: TopicCardModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(viewModel.iconName!)
                .resizable()
                .foregroundColor(Color(uiColor: UIColor.govUK.text.iconTertiary))
                .frame(width: 40, height: 40)
            Text(viewModel.title)
                .foregroundColor(Color(uiColor: UIColor.govUK.text.primary))
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color(uiColor: UIColor.govUK.text.iconTertiary))
        }
        .font(Font.govUK.bodySemibold)
        .padding(16)
        .background(Color(uiColor: UIColor.govUK.fills.surfaceList))
    }
}

#Preview {
    let model = TopicCardModel(title: "Benefits",
                               icon: UIImage(systemName: "sterlingsign.circle.fill")!,
                               tapAction: { },
                               iconName: "benefits")
    ZStack {
        Color(UIColor.govUK.fills.surfaceBackground)
        VStack {
            TopicListItemView(viewModel: model)
        }
    }
}
