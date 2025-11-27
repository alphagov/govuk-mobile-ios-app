import SwiftUI
import GOVKit
import UIComponents

struct LocalAuthorityExplainerView: View {
    private var viewModel: LocalAuthorityExplainerViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @FocusState private var isTitleFocused

    init(viewModel: LocalAuthorityExplainerViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
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
            .padding(16)
            ScrollView {
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
                    .focused($isTitleFocused)
                Text(viewModel.explainerViewDescription)
                    .font(Font.govUK.body)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .padding([.horizontal], 16)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .accessibilitySortPriority(1)
            .accessibilityElement(children: .contain)
            PrimaryButtonView(
                viewModel: viewModel.primaryButtonViewModel
            )
            .padding(.bottom, 16)
            .background(Color(uiColor: .govUK.fills.surfaceModal))
            .onAppear {
                viewModel.trackScreen(screen: self)
                isTitleFocused = true
            }
        }
    }
}

extension LocalAuthorityExplainerView: TrackableScreen {
    var trackingTitle: String? { "Your local services" }
    var trackingName: String { "Your local services" }
}
