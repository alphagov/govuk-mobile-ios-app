import SwiftUI
import Foundation
import UIComponents

struct LocalAuthorityWidget: View {
    private var viewModel: LocalAuthorityWidgetViewModel

    init(viewModel: LocalAuthorityWidgetViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.title)
                    .font(Font.govUK.title3Semibold)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            Button {
                viewModel.tapAction()
            } label: {
                CentreCard(
                    model: CentreCardModel(
                        primaryText: viewModel.description
                    )
                )
            }
        }
    }
}
