import SwiftUI
import UIComponents

struct AppErrorView: View {
    var viewModel: AppErrorViewModel?
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                errorTitle
                errorBody
                actionButton
            }
        }
        .padding()
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
    }
}
