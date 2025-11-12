import SwiftUI
import UIComponents

struct TopicSelectionCardView: View {
    @ObservedObject var viewModel: TopicSelectionCardViewModel

    var body: some View {
        HStack(spacing: 16) {
            Image(viewModel.iconName)
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text(viewModel.title)
                .font(.govUK.bodySemibold)
                .foregroundStyle(Color(viewModel.titleColor))
            Spacer()
        }
        .padding(16)
        .background(Color(viewModel.backgroundColor))
        .roundedBorder(borderColor: .clear)
        .onTapGesture {
            viewModel.isOn.toggle()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(viewModel.title). \(viewModel.accessibilitySelectedState)")
        .accessibilityAddTraits(.isButton)
    }
}
