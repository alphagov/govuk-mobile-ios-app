import Foundation
import SwiftUI

struct StoredLocalAuthorityWidgetView: View {
    private let viewModel: StoredLocalAuthorityWidgetViewModel

    init(viewModel: StoredLocalAuthorityWidgetViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                HStack {
                    Text(viewModel.title)
                        .font(Font.govUK.title3Semibold)
                        .foregroundColor(Color(uiColor: UIColor.govUK.text.primary))
                    Spacer()
                    Button {
                        viewModel.openEditViewAction()
                    } label: {
                        Text(viewModel.editButtonTitle)
                            .font(.govUK.body)
                            .foregroundColor(Color(uiColor: UIColor.govUK.text.buttonSecondary))
                    }
                    .accessibilityLabel(viewModel.editButtonAltText)
                }
                if viewModel.localAuthorities.count == 2 {
                    HStack {
                        Text(viewModel.twoTierAuthorityDescription)
                            .font(.govUK.body)
                            .foregroundColor(Color(uiColor: UIColor.govUK.text.primary))
                        Spacer()
                    }.padding(.bottom, 8)
                }
                cardView
            }
        }
    }
    @ViewBuilder
    var cardView: some View {
        ForEach(viewModel.cardModels(), id: \.name) { item in
            StoredLocalAuthorityCardView(model: item)
                .onTapGesture {
                    viewModel.openURL(
                        url: item.homepageUrl,
                        title: item.name
                    )
                }
                .padding(.bottom, 16)
        }
    }
}
