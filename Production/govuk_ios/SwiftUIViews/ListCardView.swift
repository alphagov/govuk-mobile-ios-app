import SwiftUI
import UIComponents

struct ListCardView: View {
    private let viewModel: ListCardViewModel

    init(viewModel: ListCardViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Button(action: {
            viewModel.action()
        },
        label: {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.title)
                        .font(Font.govUK.bodySemibold)
                        .foregroundStyle(Color(uiColor: .govUK.text.primary))
                        .multilineTextAlignment(.leading)
                    if let subtitle = viewModel.subtitle {
                        Text(subtitle)
                            .font(Font.govUK.body)
                            .foregroundStyle(Color(uiColor: .govUK.text.secondary))
                            .multilineTextAlignment(.leading)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(Font.govUK.bodySemibold)
                    .foregroundStyle(Color(uiColor: .govUK.text.iconTertiary))
                    .accessibilityHidden(true)
            }
        })
        .padding()
        .background(Color(uiColor: .govUK.fills.surfaceCardDefault))
        .roundedBorder(borderColor: .clear)
        .shadow(
            color: Color(uiColor: .govUK.strokes.cardDefault),
            radius: 0,
            x: 0,
            y: 3)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    let modelOne = ListCardViewModel(
        title: "Card title",
        action: { print("Tap 1") }
    )
    let modelTwo = ListCardViewModel(
        title: "Card title",
        subtitle: "Card secondary text that may go over multiple lines.",
        action: { print("Tap 2") }
    )
    ZStack {
        Color(uiColor: .govUK.fills.surfaceBackground)
        VStack(spacing: 16) {
            ListCardView(viewModel: modelOne)
            ListCardView(viewModel: modelTwo)
        }
        .padding(.horizontal)
    }
}
