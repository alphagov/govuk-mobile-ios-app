import SwiftUI
import GOVKit
import UIComponents

struct SignOutConfirmationView: View {
    private var viewModel: SignOutConfirmationViewModel

    init(viewModel: SignOutConfirmationViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                HeaderView(title: viewModel.title,
                           subheading: viewModel.subTitle)
                BulletView(bulletText: viewModel.bulletStrings)
                    .padding(.bottom, 8)
                Text(viewModel.body)
            }
            .padding(.horizontal, 16)
            ButtonStackView(
                primaryButtonViewModel: viewModel.signOutButtonViewModel,
                primaryButtonConfiguration: .destructive,
                secondaryButtonViewModel: viewModel.cancelButtonViewModel
            )
        }
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }
}

extension SignOutConfirmationView: TrackableScreen {
    var trackingTitle: String? { viewModel.title }
    var trackingName: String { "Sign Out" }
}
