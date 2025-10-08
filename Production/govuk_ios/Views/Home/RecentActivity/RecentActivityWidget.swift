import SwiftUI

struct RecentActivityWidget: View {
    @ObservedObject var viewModel: RecentActivtyHomepageWidgetViewModel
    var body: some View {
        if viewModel.recentActivities.isEmpty {
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(Font.govUK.title3Semibold)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                NonTappableCardView(
                    text: viewModel.emptyActivityStateTitle
                )
            }
        } else {
            VStack {
                HStack {
                    Text(viewModel.title)
                        .font(Font.govUK.title3Semibold)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                        .frame(alignment: .leading)
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
                VStack {
                    ForEach(0..<viewModel.recentActivities.count, id: \.self) { index in
                        RecentActivityItemCard(
                            model: viewModel.recentActivities[index],
                            isLastItemInList: viewModel.isLastActivityInList(
                                index: index
                            )
                        ).padding(
                            [.top],
                            calculatePaddingForTop(
                            index: index,
                            count: viewModel.recentActivities.count
                            )
                        )
                        .padding(
                            [.bottom],
                            calculatePaddingForBottom(
                                index: index,
                                count: viewModel.recentActivities.count
                            )
                        )
                        .padding(.horizontal, 6)
                    }
                }.background(Color(uiColor: UIColor.govUK.fills.surfaceList))
                    .roundedBorder(borderColor: .clear)
            }
        }
    }

    private func calculatePaddingForTop(index: Int, count: Int) -> CGFloat {
        index == 0 && count > 1 ? 8 : 0
    }

    private func calculatePaddingForBottom(index: Int, count: Int) -> CGFloat {
        index == viewModel.recentActivities.count - 1 && count > 1 ? 8 : 0
    }
}
