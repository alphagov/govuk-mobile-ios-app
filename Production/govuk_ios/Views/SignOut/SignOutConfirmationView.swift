import SwiftUI
import GOVKit
import UIComponents

struct SignOutConfirmationView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    private var viewModel: SignOutConfirmationViewModel

    init(viewModel: SignOutConfirmationViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HeaderView(title: viewModel.title,
                           subheading: viewModel.subTitle)
                BulletView(bulletText: viewModel.bulletStrings)
                    .padding(.bottom, 8)
                Text(viewModel.body)
            }
            .padding(.horizontal, 16)
            Spacer()
            Divider()
                .overlay(Color(UIColor.govUK.strokes.listDivider))
                .ignoresSafeArea()
            let buttonLayout = verticalSizeClass == .compact ?
            AnyLayout(HStackLayout()) :
            AnyLayout(VStackLayout())
            buttonLayout {
                SwiftUIButton(
                    .destructive,
                    viewModel: viewModel.signOutButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                SwiftUIButton(
                    .secondary,
                    viewModel: viewModel.cancelButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
            }
            .ignoresSafeArea()
            .padding(16)
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
