import SwiftUI
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
                        HeaderViewComponent(
                            model: HeaderViewModel(
                                title: viewModel.title,
                                secondaryButton: .init(
                                    title: viewModel.seeAllButtonTitle,
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
                HeaderViewComponent(
                    model: HeaderViewModel(
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
