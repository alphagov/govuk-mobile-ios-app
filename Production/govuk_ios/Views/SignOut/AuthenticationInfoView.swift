import SwiftUI
import GOVKit
import UIComponents

struct AuthenticationInfoView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    private var viewModel: AuthenticationInfoViewModelInterface

    init(viewModel: AuthenticationInfoViewModelInterface) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollView {
                    infoView
                        .frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height)
                }
            }
            Divider()
                .overlay(Color(UIColor.govUK.strokes.listDivider))
                .ignoresSafeArea()
            SwiftUIButton(
                .primary,
                viewModel: viewModel.buttonViewModel
            )
            .frame(minHeight: 44, idealHeight: 44)
            .padding(16)
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private var infoView: some View {
        VStack {
            if let image = viewModel.image {
                image
                    .font(Font.system(size: 107, weight: .light))
            }
            Text(viewModel.title)
                .fontWeight(.bold)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.title1)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
                .padding(.bottom, 16)
            Text(viewModel.subtitle)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.body)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
    }
}

extension AuthenticationInfoView: TrackableScreen {
    var trackingName: String {
        viewModel.trackingName
    }

    var trackingTitle: String? {
        viewModel.trackingTitle
    }
}
