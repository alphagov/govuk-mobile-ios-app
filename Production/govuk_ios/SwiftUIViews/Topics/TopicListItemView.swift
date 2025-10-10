import SwiftUI
import GOVKit
import UIComponents

struct TopicListItemView: View {
    private var viewModel: TopicListItemViewModel
    init(viewModel: TopicListItemViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(viewModel.iconName)
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
        .padding()
        .background(viewModel.backgroundColor)
        .onTapGesture {
            viewModel.tapAction()
        }
    }
}

#Preview {
    let model1 = TopicListItemViewModel(title: "Benefits",
                               tapAction: { print("tap 1") },
                               iconName: "benefits")
    let model2 = TopicListItemViewModel(title: "Care",
                                tapAction: { print("tap 2") },
                                iconName: "care",
                                backgroundColor: Color(UIColor.govUK.fills.surfaceCardBlue))
    ZStack {
        Color(UIColor.govUK.fills.surfaceBackground)
        VStack {
            TopicListItemView(viewModel: model1)
            TopicListItemView(viewModel: model2)
        }
    }
}
