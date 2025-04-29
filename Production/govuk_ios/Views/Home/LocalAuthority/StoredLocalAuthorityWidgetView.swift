import Foundation
import SwiftUI

struct StoredLocalAuthorityWidgetView: View {
    private let viewModel: StoredLocalAuthorityWidgetViewModel

    init(viewModel: StoredLocalAuthorityWidgetViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(viewModel.title)
                    .font(Font.govUK.bodySemibold)
                Spacer()
                Button {
                    viewModel.openEditViewAction()
                } label: {
                    Text(viewModel.editButtonTitle)
                        .foregroundColor(Color(uiColor: UIColor.govUK.text.buttonSecondary))
                }
            }
            if viewModel.localAuthorities.count == 2 {
                HStack {
                    Text(viewModel.twoTierAuthorityDescription)
                    Spacer()
                }
            }
            cardView
        }
    }
    @ViewBuilder
    var cardView: some View {
        ForEach(viewModel.returnCards(), id: \.name) { item in
            StoredLocalAuthorityCardView(model: item)
                .onTapGesture {
                    viewModel.openURL(
                        url: item.homepageUrl,
                        title: item.name
                    )
                }
        }
    }
}
