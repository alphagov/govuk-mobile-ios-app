import SwiftUI
import GOVKit
import UIComponents

struct InfoView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    private var viewModel: any InfoViewModelInterface

    init(viewModel: any InfoViewModelInterface) {
        self.viewModel = viewModel
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
            Divider()
                .overlay(Color(UIColor.govUK.strokes.listDivider))
                .ignoresSafeArea()
                .opacity(viewModel.showDivider ? 1.0 : 0.0)
            SwiftUIButton(
                viewModel.buttonConfiguration,
                viewModel: viewModel.buttonViewModel
            )
            .frame(minHeight: 44, idealHeight: 44)
            .padding(16)
            .ignoresSafeArea()
            .opacity(viewModel.showActionButton ? 1.0 : 0.0)
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
        .environment(\.openURL, OpenURLAction { url in
            viewModel.openURLAction?(url)
            return .handled
        })
    }

    private var infoView: some View {
        VStack {
            if verticalSizeClass != .compact || viewModel.showImageWhenCompact {
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
