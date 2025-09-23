import SwiftUI
import CoreData
import UIComponents
import GOVKit

struct RecentActivityWidget: View {
    @ObservedObject var viewModel: RecentActivtyHomepageWidgetViewModel
    @ScaledMetric var scale: CGFloat = 1
    var body: some View {
        if viewModel.recentActivities.isEmpty {
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(Font.govUK.title3Semibold)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .padding(.horizontal)
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
                    Spacer()
                    SwiftUIButton(.secondary, viewModel: viewModel.showAllButtonViewModel)
                        .frame(width: 100 * scale)
                        .padding([.leading], 70)
                }
                .padding(.leading)
                VStack {
                    ForEach(0..<viewModel.recentActivities.count, id: \.self) { index in
                        RecentActivityItemCard(
                            model: viewModel.recentActivities[index],
                            postitionInList: index,
                            isLastItemInList: viewModel.isLastActivityInList(
                                index: index
                            )
                        ).padding([.horizontal])
                            .padding([.top], index == 0 ? 8: 0)
                    }
                }.background(Color(uiColor: UIColor.govUK.fills.surfaceList))
                    .roundedBorder(borderColor: .clear)
                    .padding(.horizontal)
                    .padding(.top, 8)
            }
        }
    }
}
