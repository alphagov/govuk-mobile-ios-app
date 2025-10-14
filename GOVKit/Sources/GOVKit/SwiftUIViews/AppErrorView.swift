import SwiftUI
import UIComponents

public struct AppErrorView: View {
    public var viewModel: AppErrorViewModel?

    public init(viewModel: AppErrorViewModel? = nil) {
        self.viewModel = viewModel
    }

    public var body: some View {
            VStack(spacing: 8) {
                warningImage
                errorTitle
                errorBody
                actionButton
            }
        .padding()
    }

    private var warningImage: some View {
        Image(systemName: "exclamationmark.circle")
            .resizable()
            .frame(width: 31, height: 31)
            .foregroundColor(Color(uiColor: .govUK.text.iconTertiary))
            .fontWeight(.light)
    }

    private var errorTitle: some View {
        Text(viewModel?.title ?? "")
            .font(.govUK.bodySemibold)
            .multilineTextAlignment(.center)
    }

    private var errorBody: some View {
        VStack {
            Text(viewModel?.body ?? "")
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
        }
    }

    private var actionButton: some View {
        Button(viewModel?.buttonTitle ?? "") {
            viewModel?.action?()
        }
        .foregroundColor(Color(UIColor.govUK.text.link))
        .accessibilityLabel(
            Text(viewModel?.buttonAccessibilityLabel
                 ?? viewModel?.buttonTitle
                 ?? "")
            )
        .accessibilityRemoveTraits(.isButton)
        .accessibilityAddTraits(
            (viewModel?.isWebLink ?? false)
            ? .isLink
            : .isButton
        )
        .accessibilityHint(
            (viewModel?.isWebLink ?? false)
            ? String.common.localized("openWebLinkHint")
            : ""
        )
        .opacity(viewModel?.buttonTitle == nil ? 0 : 1)
    }
}
