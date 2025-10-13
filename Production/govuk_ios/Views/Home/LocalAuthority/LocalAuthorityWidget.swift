import SwiftUI
import Foundation
import UIComponents

struct LocalAuthorityWidget: View {
    private var viewModel: LocalAuthorityWidgetViewModel

    init(viewModel: LocalAuthorityWidgetViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Button {
            viewModel.tapAction()
        } label: {
            VStack {
                HStack {
                    Text(viewModel.title)
                        .font(Font.govUK.title3Semibold)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                    Spacer()
                }
                .padding(.bottom, 12)
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center) {
                        Spacer()
                        Image(systemName: "plus.circle")
                            .foregroundColor(
                                Color(
                                    UIColor.govUK.text.iconTertiary
                                )
                            )
                            .padding(.bottom, 6)
                            .font(.title)
                        Text(viewModel.description)
                            .multilineTextAlignment(.center)
                            .font(Font.govUK.body)
                            .foregroundColor(
                                Color(UIColor.govUK.text.primary))
                            .padding(.horizontal)
                        Spacer()
                    }
                    .padding()
                    Spacer()
                }
                .background {
                    Color(uiColor: UIColor.govUK.fills.surfaceList)
                }
                .roundedBorder(borderColor: .clear)
                .shadow(
                    color: Color(
                        uiColor: UIColor.govUK.strokes.cardDefault
                    ), radius: 0, x: 0, y: 3
                )
            }
        }
    }
}
