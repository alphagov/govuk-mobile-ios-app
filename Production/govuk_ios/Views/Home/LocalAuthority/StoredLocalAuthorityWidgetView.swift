import Foundation
import SwiftUI

struct StoredLocalAuthorityWidgetView: View {
    private let viewModel: StoredLocalAuthorityWidgetViewModel

    init(viewModel: StoredLocalAuthorityWidgetViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(viewModel.title)
                        .font(Font.govUK.title3Semibold)
                        .foregroundColor(Color(uiColor: UIColor.govUK.text.primary))
                        .accessibilityAddTraits(.isHeader)
                    Spacer()
                    Button {
                        viewModel.openEditViewAction()
                    } label: {
                        Text(viewModel.editButtonTitle)
                            .font(.govUK.subheadlineSemibold)
                            .foregroundColor(Color(uiColor: UIColor.govUK.text.buttonSecondary))
                    }
                    .accessibilityLabel(viewModel.editButtonAltText)
                }
                .padding(.bottom, 8)
                if viewModel.localAuthorities.count == 2 {
                    HStack {
                        Text(viewModel.twoTierAuthorityDescription)
                            .font(.govUK.body)
                            .foregroundColor(Color(uiColor: UIColor.govUK.text.primary))
                        Spacer()
                    }.padding(.bottom, 8)
                    VStack {
                        Text(viewModel.cardModels().first?.name ?? "")
                            .font(.govUK.title2Bold)
                            .foregroundColor(Color(uiColor: UIColor.govUK.text.link))
                    }
                    .roundedBorder(borderColor: .clear)
                    .shadow(
                        color: Color(
                            uiColor: UIColor.govUK.strokes.cardDefault
                        ), radius: 0, x: 0, y: 3
                    )
                } else {
                    twoTierView
                }
            }
        }
        .background(Color(uiColor: UIColor.govUK.fills.surfaceBackground))
    }
    @ViewBuilder
    var twoTierView: some View {
        ForEach(viewModel.cardModels(), id: \.name) { item in
            StoredLocalAuthorityCardView(model: item)
                .onTapGesture {
                    viewModel.open(item: item)
                }
                .padding(.bottom, 16)
        }
    }
}
