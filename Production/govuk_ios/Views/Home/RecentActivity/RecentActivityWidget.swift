import SwiftUI
import GOVKit

struct RecentActivityWidget: View {
    @ObservedObject var viewModel: RecentActivityHomepageWidgetViewModel
    var body: some View {
        if viewModel.sections.isEmpty {
            VStack(alignment: .leading) {
                titleView
                    .padding(.top, 16)
                    .padding(.horizontal)
                NonTappableCardView(
                    text: viewModel.emptyActivityStateTitle
                )
                .padding(.horizontal)
                .padding(.top, 4)
            }
            .padding(.top)
        } else {
            VStack {
                HStack {
                    titleView
                    Spacer()
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
                .padding(.top, 16)
            }
            .padding(.top)
            .padding(.horizontal)
            VStack {
                GroupedList(
                    content: viewModel.sections,
                    backgroundColor: UIColor.govUK.fills.surfaceBackground
                )
                .padding(.top, -10)
            }
        }
    }

    private var titleView: some View {
        Text(viewModel.title)
            .font(Font.govUK.title3Semibold)
            .foregroundColor(Color(UIColor.govUK.text.primary))
    }
}
