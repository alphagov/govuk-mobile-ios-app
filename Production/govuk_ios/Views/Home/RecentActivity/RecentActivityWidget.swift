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
                                .foregroundColor(Color(UIColor.govUK.text.link))
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
                        ).padding([.top], index == 0 ? 8: 0)
                    }
                }.background(Color(uiColor: UIColor.govUK.fills.surfaceList))
                    .roundedBorder(borderColor: .clear)
            }
            }
        }
    }
