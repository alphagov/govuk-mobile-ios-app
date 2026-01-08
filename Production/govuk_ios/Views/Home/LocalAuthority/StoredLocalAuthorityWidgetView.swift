import Foundation
import SwiftUI
import UIComponents

struct StoredLocalAuthorityWidgetView: View {
    private let viewModel: StoredLocalAuthorityWidgetViewModel

    init(viewModel: StoredLocalAuthorityWidgetViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            SectionHeaderLabelView(
                model: SectionHeaderLabelViewModel(
                    title: viewModel.title,
                    button: .init(
                        localisedTitle: viewModel.editButtonTitle,
                        localisedAccessibilityLabel: viewModel.editButtonAltText,
                        action: { viewModel.openEditViewAction() }
                    )
                )
            )
            .padding(.bottom, 8)
            .padding(.top, 16)
            if viewModel.localAuthorities.count == 1,
               let item = viewModel.cardModels().first {
                StoredLocalAuthorityCardView(model: item)
                    .onTapGesture {
                        viewModel.open(item: item)
                    }
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
        .padding(.horizontal)
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
