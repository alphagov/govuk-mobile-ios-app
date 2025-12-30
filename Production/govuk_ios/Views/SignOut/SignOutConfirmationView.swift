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
                .padding(.bottom, 12)
                BulletView(bulletText: viewModel.bulletStrings)
                    .padding(.bottom, 16)
                Text(viewModel.body)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            ButtonStackView(
                primaryButtonViewModel: viewModel.signOutButtonViewModel,
                primaryButtonConfiguration: .destructive,
                secondaryButtonViewModel: viewModel.cancelButtonViewModel
            )
        }.background(Color(UIColor.govUK.fills.surfaceModal))
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }
}

extension SignOutConfirmationView: TrackableScreen {
    var trackingTitle: String? { viewModel.title }
    var trackingName: String { "Sign Out" }
}
