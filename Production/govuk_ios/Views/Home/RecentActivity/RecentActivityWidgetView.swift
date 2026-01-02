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
                    HStack {
                        titleView
                        Spacer()
                        seeAllButton
                    }
                    .padding(.horizontal, 16)
                    GroupedList(
                        content: viewModel.sections
                    )
                    .padding(.top, 16)
                }
            )
        }
    }

    private var titleView: some View {
        Text(viewModel.title)
            .font(Font.govUK.title3Semibold)
            .foregroundColor(Color(UIColor.govUK.text.primary))
            .accessibility(addTraits: .isHeader)
    }

    private var emptyStateView: some View {
        VStack(
            alignment: .leading,
            spacing: .zero,
            content: {
                titleView
                    .padding(.horizontal, 16)
                NonTappableCardView(
                    text: viewModel.emptyActivityStateTitle
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        )
    }

    private var seeAllButton: some View {
        Button(
            action: {
                viewModel.seeAllAction()
            }, label: {
                Text(viewModel.seeAllButtonTitle)
                    .foregroundColor(
                        Color(UIColor.govUK.text.buttonSecondary)
                    )
                    .font(Font.govUK.subheadlineSemibold)
            }
        )
    }
}
