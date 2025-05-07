import SwiftUI
import Foundation
import UIComponents

struct LocalAuthorityWidgetView: View {
    private var viewModel: LocalAuthorityWidgetViewModel

    init(viewModel: LocalAuthorityWidgetViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.titleOne)
                    .font(Font.govUK.bodySemibold)
                Spacer()
            }
            Divider().overlay(Color(cgColor: UIColor.govUK.strokes.cardGreen.cgColor))
            HStack {
                Image("local_widget_icon")
                VStack(alignment: .leading) {
                    Text(viewModel.titleTwo)
                        .font(Font.govUK.bodySemibold)
                    Text(viewModel.description)
                        .font(Font.govUK.subheadline)
                        .foregroundColor(
                            Color(
                                UIColor.govUK.text.secondary
                            )
                        )
                }
                Spacer()
            }
        }
        .accessibilityElement(children: .combine)
        .background {
            Color(uiColor: UIColor.govUK.fills.surfaceCardSelected)
                .ignoresSafeArea()
        }
        .onTapGesture {
            viewModel.tapAction()
        }
    }
}
