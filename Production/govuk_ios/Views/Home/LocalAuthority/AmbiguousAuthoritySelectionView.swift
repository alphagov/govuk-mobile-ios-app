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
            Divider()
                .overlay(Color(UIColor.govUK.strokes.listDivider))
                .ignoresSafeArea()
            let buttonLayout = verticalSizeClass == .compact ?
            AnyLayout(HStackLayout()) :
            AnyLayout(VStackLayout())
            buttonLayout {
                SwiftUIButton(
                    .primary,
                    viewModel: viewModel.confirmButtonModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                .disabled(viewModel.selectedAuthority == nil)
                SwiftUIButton(
                    .secondary,
                    viewModel: viewModel.selectAddressButtonModel
                )
                .frame(minHeight: 44, idealHeight: 44)
            }
            .ignoresSafeArea()
            .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
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
