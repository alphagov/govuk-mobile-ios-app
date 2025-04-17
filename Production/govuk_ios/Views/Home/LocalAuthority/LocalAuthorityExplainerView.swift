import SwiftUI
import GOVKit
import UIComponents

struct LocalAuthorityExplainerView: View {
    @StateObject private var viewModel: LocalAuthorityViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.dismiss) var dismiss

    init(viewModel: LocalAuthorityViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        if verticalSizeClass != .compact {
                            let imageResource = ImageResource(
                                name: "onboarding_screen_1",
                                bundle: .main
                            )
                            Image(imageResource)
                                .scaledToFit()
                                .frame(width: 290, height: 290)
                        }
                        Text(viewModel.explainerViewTitle)
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .accessibilityLabel(Text(viewModel.explainerViewTitle))
                            .padding([.trailing, .leading], 16)
                            .accessibilityAddTraits(.isHeader)
                            .accessibilitySortPriority(1)
                        Text(viewModel.explainerViewDescription)
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                            .multilineTextAlignment(.center)
                            .accessibilityLabel(Text(viewModel.explainerViewDescription))
                            .padding([.top, .leading, .trailing], 4)
                            .accessibilitySortPriority(0)
                        Spacer()
                    }
                    .accessibilityElement(children: .contain)
                }
                    buttons
            }.navigationTitle(viewModel.navigationTitle)
                .toolbar {
                    doneButton
                }
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $viewModel.showPostcodeEntryView) {
                    LocalAuthorityPostcodeEntryView(viewModel: viewModel)
                }
        }.onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private var doneButton: some ToolbarContent {
        ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
            Button(viewModel.cancelButtonTitle) {
                dismiss()
            }
            .foregroundColor(Color(UIColor.govUK.text.link))
        }
    }

    @ViewBuilder
    var buttons: some View {
        let layout = verticalSizeClass == .compact ?
        AnyLayout(HStackLayout()) :
        AnyLayout(VStackLayout())
        VStack(alignment: .center, spacing: 16) {
            Divider()
                .background(Color(UIColor.govUK.strokes.listDivider))
                .ignoresSafeArea(edges: [.leading, .trailing])
                .padding([.top], 0)
            layout {
                SwiftUIButton(
                    .primary,
                    viewModel: viewModel.explainerViewPrimaryButtonViewModel
                )
                .frame(
                    minHeight: 44,
                    idealHeight: 44
                )
            }
            .padding([.leading, .trailing], verticalSizeClass == .regular ? 16 : 0)
        }
        .accessibilityElement(children: .contain)
    }
}

extension LocalAuthorityExplainerView: TrackableScreen {
    var trackingTitle: String? { "Your local services" }
    var trackingName: String { "Your local services" }
}
