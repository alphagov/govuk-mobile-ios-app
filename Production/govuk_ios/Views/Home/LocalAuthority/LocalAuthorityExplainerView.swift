import SwiftUI
import GOVKit
import UIComponents

struct LocalAuthorityExplainerView: View {
    private var viewModel: LocalAuthorityExplainerViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: LocalAuthorityExplainerViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        ZStack {
            Color(uiColor: .govUK.fills.surfaceModal)
            VStack {
                HStack {
                    Spacer()
                    Button(
                        action: {
                            viewModel.dismissAction()
                        }, label: {
                            Text(String.common.localized("cancel"))
                                .foregroundColor(
                                    Color(UIColor.govUK.text.linkSecondary)
                                )
                                .font(Font.govUK.subheadlineSemibold)
                        }
                    )
                }
                .padding()
                ScrollView {
                    VStack {
                        if verticalSizeClass != .compact {
                            Image(decorative: "your_local_services")
                                .scaledToFit()
                                .frame(width: 290, height: 290)
                        }
                        Text(viewModel.explainerViewTitle)
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                            .font(Font.govUK.largeTitleBold)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding([.horizontal], 16)
                            .padding(.bottom, 4)
                            .accessibilityAddTraits(.isHeader)
                        Text(viewModel.explainerViewDescription)
                            .font(Font.govUK.body)
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                            .padding([.horizontal], 16)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .accessibilityElement(children: .contain)
                }
                PrimaryButtonView(
                    viewModel: viewModel.primaryButtonViewModel
                )
                .padding(.bottom, 16)
            }
            .onAppear {
                viewModel.trackScreen(screen: self)
            }
        }
    }
}

extension LocalAuthorityExplainerView: TrackableScreen {
    var trackingTitle: String? { "Your local services" }
    var trackingName: String { "Your local services" }
}
