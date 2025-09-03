import SwiftUI
import GOVKit
import UIComponents

struct InfoView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    private var viewModel: any InfoViewModelInterface
    private let customView: (() -> AnyView)?

    init(viewModel: any InfoViewModelInterface,
         customView: (() -> AnyView)? = nil) {
        self.viewModel = viewModel
        self.customView = customView
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollView {
                    infoView
                        .frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height)
                }.modifier(ScrollBounceBehaviorModifier())
            }
            if let secondaryButtonViewModel = viewModel.secondaryButtonViewModel {
                ButtonStackView(
                    primaryButtonViewModel: viewModel.primaryButtonViewModel,
                    secondaryButtonViewModel: secondaryButtonViewModel
                )
            } else if viewModel.showPrimaryButton {
                Divider()
                    .overlay(Color(UIColor.govUK.strokes.listDivider))
                SwiftUIButton(
                    viewModel.primaryButtonConfiguration,
                    viewModel: viewModel.primaryButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                .padding(16)
            }
        }
        .navigationBarHidden(viewModel.navBarHidden)
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private var infoView: some View {
        VStack {
            if verticalSizeClass != .compact {
                viewModel.image
                    .accessibilityHidden(true)
            }

            Text(viewModel.title)
                .fontWeight(.bold)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.largeTitleBold)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
                .padding(.bottom, 16)
            Text(LocalizedStringKey(viewModel.subtitle))
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(viewModel.subtitleFont)
                .multilineTextAlignment(.center)

            customView?()
        }
        .padding(.horizontal, 16)
    }
}

extension InfoView: TrackableScreen {
    var trackingName: String {
        viewModel.trackingName
    }

    var trackingTitle: String? {
        viewModel.trackingTitle
    }
}

struct InfoSystemImage: View {
    let imageName: String

    var body: some View {
        Image(systemName: imageName)
            .font(.system(size: 107, weight: .light))
    }
}
