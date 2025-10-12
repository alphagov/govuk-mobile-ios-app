import Foundation
import SwiftUI

struct StoredLocalAuthorityWidgetView: View {
    private let viewModel: StoredLocalAuthorityWidgetViewModel

    init(viewModel: StoredLocalAuthorityWidgetViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HStack {
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
                        .foregroundColor(
                            Color(uiColor: UIColor.govUK.text.buttonSecondary
                                 )
                        )
                }
                .accessibilityLabel(viewModel.editButtonAltText)
            }
            .padding(.bottom, 8)
            if viewModel.localAuthorities.count == 1 {
                StoredLocalAuthorityCardView(model: viewModel.cardModels()[0])
            } else {
                HStack {
                    Text(viewModel.twoTierAuthorityDescription)
                        .font(.govUK.body)
                        .foregroundColor(Color(uiColor: UIColor.govUK.text.primary))
                        .padding(.bottom, 4)
                    Spacer()
                }
                twoTierView
            }
        }
    }
    @ViewBuilder
    var twoTierView: some View {
        ForEach(viewModel.cardModels(), id: \.name) { item in
            StoredLocalAuthorityCardView(model: item)
                .onTapGesture {
                    viewModel.open(item: item)
                }
                .padding(.bottom, 2)
        }
    }
}
