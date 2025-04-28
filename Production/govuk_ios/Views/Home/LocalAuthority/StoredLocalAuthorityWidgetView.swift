import Foundation
import SwiftUI

struct StoredLocalAuthorityWidgetView: View {
    private let viewModel: StoredLocalAuthrorityWidgetViewModel

    init(viewModel: StoredLocalAuthrorityWidgetViewModel) {
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
            storedCardViews
        }
    }
    @ViewBuilder
    var storedCardViews: some View {
        ForEach(viewModel.convertModel(), id: \.name) { item in
            StoredLocalAuthrorityCardView(model: item)
                .onTapGesture {
                    viewModel.openURL(
                        url: item.homepageUrl,
                        title: item.name
                    )
                }
        }
    }
}
