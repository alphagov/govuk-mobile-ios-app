import SwiftUI
import Foundation
import UIComponents

struct LocalAuthorityWidget: View {
    private var viewModel: LocalAuthorityWidgetViewModel

    init(viewModel: LocalAuthorityWidgetViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Button(
            action: {
                viewModel.tapAction()
            }, label: {
                VStack {
                    HStack {
                        Text(viewModel.title)
                            .font(Font.govUK.title3Semibold)
                            .foregroundColor(
                                Color(UIColor.govUK.text.primary
                                     )
                            )
                        Spacer()
                        Button(
                            action: {
                                viewModel.editAction()
                            }, label: {
                                Text(viewModel.editButtonTitle)
                                    .foregroundColor(Color(UIColor.govUK.text.link))
                                    .font(Font.govUK.subheadlineSemibold)
                            }
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                    VStack(alignment: .center) {
                        Image(systemName: "plus.circle")
                            .padding(.bottom, 6)
                            .padding(.top, 20)
                            .padding(.horizontal)
                            .font(.title2)
                        Text(viewModel.description)
                            .font(Font.govUK.body)
                            .padding(.horizontal)
                            .foregroundColor(
                                Color(UIColor.govUK.text.primary
                                     ))
                            .padding(.bottom, 20)
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
                    .padding([.horizontal])
                }.padding(.top, 8)
            }
        )
    }
}
