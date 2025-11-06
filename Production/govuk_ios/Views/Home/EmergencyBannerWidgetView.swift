import SwiftUI

struct EmergencyBannerWidgetView: View {
    let viewModel: EmergencyBannerWidgetViewModel

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    title
                    description
                }
                Spacer()
                dismissButton
            }
            if let titlelinkTitle = viewModel.link?.title,
               !titlelinkTitle.isEmpty {
                divider
                HStack {
                    linkButton(title: titlelinkTitle)
                    Spacer()
                }
            }
        }
        .padding()
        .background(viewModel.backgroundColor)
        .roundedBorder(borderColor: viewModel.borderColor)
        .padding([.horizontal, .top])
    }

    @ViewBuilder
    private var title: some View {
        if let title = viewModel.title {
            Text(title)
                .font(.govUK.title2Bold)
                .foregroundColor(viewModel.foregroundColor)
                .accessibilitySortPriority(viewModel.sortPriority)
                .padding(.bottom, 4)
        } else {
            EmptyView()
        }
    }

    private var description: some View {
        Text(viewModel.body)
            .font(.govUK.body)
            .foregroundColor(viewModel.foregroundColor)
            .accessibilitySortPriority(viewModel.sortPriority - 1)
    }

    private var dismissButton: some View {
        Button {
            withAnimation {
                viewModel.dismiss()
            }
        } label: {
            Image(systemName: "xmark")
                .font(.govUK.bodySemibold)
        }
        .accessibilityLabel(
            String.home.localized("dismissAlertBannerAccessibilityLabel")
        )
        .opacity(viewModel.allowsDismissal ? 1 : 0)
        .foregroundColor(viewModel.dismissButtonColor)
        .accessibilitySortPriority(viewModel.sortPriority - 3)
    }

    @ViewBuilder
    private var divider: some View {
        if viewModel.type != .information {
            Divider()
                .overlay(.white)
                .padding(.vertical, 6)
        } else {
            EmptyView()
        }
    }

    private func linkButton(title: String) -> some View {
        Button(
            action: {
                self.viewModel.open()
            }, label: {
                HStack {
                    Text(title)
                        .multilineTextAlignment(.leading)
                        .font(.govUK.body)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.govUK.bodySemibold)
                        .padding(.trailing, -4)
                        .opacity(viewModel.type == .information ? 0.0 : 1.0)
                }
                .foregroundColor(viewModel.linkColor)
            }
        )
        .padding(.vertical, 8)
        .accessibilityRemoveTraits(.isButton)
        .accessibilityAddTraits(.isLink)
        .accessibilityHint(String.common.localized("openWebLinkHint"))
        .accessibilitySortPriority(viewModel.sortPriority - 2)
    }
}
