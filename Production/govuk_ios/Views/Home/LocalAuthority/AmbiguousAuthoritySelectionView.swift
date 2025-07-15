import SwiftUI
import GOVKit
import UIComponents

struct AmbiguousAuthoritySelectionView: View {
    @StateObject private var viewModel: AmbiguousAuthoritySelectionViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: AmbiguousAuthoritySelectionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ScrollView {
                HeaderView(
                    title: viewModel.title,
                    subheading: viewModel.subtitle
                )
                .padding()
                listView
                Spacer()
            }
            ButtonStackView(
                primaryButtonViewModel: viewModel.confirmButtonModel,
                primaryDisabled: viewModel.selectedAuthority == nil,
                secondaryButtonViewModel: viewModel.selectAddressButtonModel)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            cancelButton
        }
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private var listView: some View {
        ForEach(
            viewModel.localAuthorities,
            id: \.slug
        ) { authority in
            RadioButtonView(
                title: authority.name,
                selected: isSelected(authority.slug),
                isLastRow: viewModel.localAuthorities.last?.slug == authority.slug
            )
            .onTapGesture {
                viewModel.selectedAuthority = authority
            }
        }
        .padding(.horizontal, 16)
    }

    private var cancelButton: some ToolbarContent {
        ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
            Button(viewModel.cancelButtonTitle) {
                viewModel.dismissAction()
            }
            .foregroundColor(Color(UIColor.govUK.text.link))
        }
    }

    private func isSelected(_ slug: String) -> Binding<Bool> {
        return .constant(slug == viewModel.selectedAuthority?.slug)
    }
}

extension AmbiguousAuthoritySelectionView: TrackableScreen {
    var trackingTitle: String? { "What is your local council" }
    var trackingName: String { "What is your local council" }
}
