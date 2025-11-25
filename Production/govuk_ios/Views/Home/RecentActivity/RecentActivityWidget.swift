import SwiftUI
import GOVKit

struct RecentActivityWidget: View {
    @ObservedObject var viewModel: RecentActivityHomepageWidgetViewModel
    var body: some View {
        if viewModel.sections.isEmpty {
            emptyStateView
        } else {
            VStack {
                HStack {
                    titleView
                    Spacer()
                    seeAllButton
                }
                .padding(.top, 16)
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            GroupedList(
                content: viewModel.sections,
                backgroundColor: UIColor.govUK.fills.surfaceBackground
            )
            .padding(.top, -10)
        }
    }

    private var titleView: some View {
        Text(viewModel.title)
            .font(Font.govUK.title3Semibold)
            .foregroundColor(Color(UIColor.govUK.text.primary))
    }

    private var emptyStateView: some View {
        VStack(alignment: .leading) {
            titleView
                .padding(.top, 16)
                .padding(.horizontal, 16)
            NonTappableCardView(
                text: viewModel.emptyActivityStateTitle
            )
            .padding(.horizontal, 16)
            .padding(.top, 4)
        }
        .padding(.top, 16)
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
