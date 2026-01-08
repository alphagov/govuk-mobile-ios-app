import SwiftUI
import UIComponents
import GOVKit

struct RecentActivityWidgetView: View {
    @ObservedObject var viewModel: RecentActivityHomepageWidgetViewModel
    var body: some View {
        if viewModel.sections.isEmpty {
            emptyStateView
        } else {
            VStack(
                alignment: .leading,
                spacing: .zero,
                content: {
                    SectionHeaderLabelView(
                        model: SectionHeaderLabelViewModel(
                        title: viewModel.title,
                        button: .init(
                            localisedTitle: viewModel.seeAllButtonTitle,
                            action: { viewModel.seeAllAction() }
                        )
                    )
                )
                .padding(.horizontal, 16)
                    GroupedList(
                        content: viewModel.sections
                    )
                    .padding(.top, 16)
                }
            )
        }
    }
    private var emptyStateView: some View {
        VStack(
            alignment: .leading,
            spacing: .zero,
            content: {
                SectionHeaderLabelView(
                    model: .init(
                        title: viewModel.title
                    )
                )
                .padding(.horizontal, 16)
                NonTappableCardView(
                    text: viewModel.emptyActivityStateTitle
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        )
    }
}
