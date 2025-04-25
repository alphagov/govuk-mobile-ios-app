import Foundation

struct StoredLocalAuthorityWidgetView: View {
    let viewModel: StoredLocalAuthrorityCardViewModel
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Your local services")
                    .font(Font.govUK.bodySemibold)
                Spacer()
                Button(String.common.localized("editButtonTitle")) { }
            }
            HStack {
                Text("Services in your area are provided by 2 local councils")
                Spacer()
            }
            StoredLocalAuthrorityCardView(
                model: viewModel.model
            ).onTapGesture {
                viewModel.openURL(
                    url: viewModel.model.homepageUrl,
                    title: ""
                )
            }
            if let parentAuthority = viewModel.model.parent {
                StoredLocalAuthrorityCardView(
                    model: parentAuthority
                ).onTapGesture {
                    viewModel.openURL(
                        url: parentAuthority.homepageUrl,
                        title: ""
                    )
                }
                .padding(.top, 4)
            }
        }
    }
}
