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
        VStack {
            ScrollView {
                VStack {
                    if verticalSizeClass != .compact {
                        Image(decorative: "your_local_services")
                            .scaledToFit()
                            .frame(width: 290, height: 290)
                    }
                    Text(viewModel.explainerViewTitle)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding([.horizontal], 16)
                        .padding(.bottom, 4)
                        .accessibilityAddTraits(.isHeader)
                    Text(viewModel.explainerViewDescription)
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
        }.toolbar {
            cancelButton
        }.onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private var cancelButton: some ToolbarContent {
        ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
            Button(viewModel.cancelButtonTitle) {
                viewModel.dismissAction()
            }
            .foregroundColor(Color(UIColor.govUK.text.link))
        }
    }
}

extension LocalAuthorityExplainerView: TrackableScreen {
    var trackingTitle: String? { "Your local services" }
    var trackingName: String { "Your local services" }
}
