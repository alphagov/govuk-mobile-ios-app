import SwiftUI
import GOVKit
import UIComponents

struct LocalAuthorityPostcodeEntryView: View {
    @StateObject private var viewModel: LocalAuthorityPostcodeEntryViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @AccessibilityFocusState(for: .voiceOver)
    private var isErrorFocused: Bool

    init(viewModel: LocalAuthorityPostcodeEntryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text(viewModel.postcodeEntryViewTitle)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                        .font(Font.govUK.title1Bold)
                        .accessibilityAddTraits(.isHeader)
                    Text(viewModel.postcodeEntryViewExampleText)
                        .font(Font.govUK.body)
                        .foregroundColor(Color(UIColor.govUK.text.secondary))
                    if let errorCase = viewModel.error {
                        withAnimation {
                            Text(errorCase.errorMessage)
                                .accessibilityFocused($isErrorFocused)
                                .foregroundColor(
                                    Color(uiColor: UIColor.govUK.text.buttonDestructive)
                                )
                                .font(Font.govUK.body)
                        }
                    }
                    TextField("", text: $viewModel.postCode)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityLabel(viewModel.entryFieldAccessibilityLabel)
                    Text(viewModel.postcodeEntryViewDescriptionTitle)
                        .font(Font.govUK.bodySemibold)
                        .accessibilityAddTraits(.isHeader)
                    Text(viewModel.postcodeEntryViewDescriptionBody)
                        .font(Font.govUK.body)
                    Spacer()
                }.padding()
            }.onReceive(viewModel.$error) { error in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if error != nil {
                        isErrorFocused = true
                    }
                }
            }
            PrimaryButtonView(
                viewModel: viewModel.primaryButtonViewModel
            )
            .disabled(viewModel.postCode.isEmpty)
        }.toolbar {
            cancelButton
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private var cancelButton: some ToolbarContent {
        ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
            Button(viewModel.cancelButtonTitle) {
                viewModel.dismissAction()
            }
            .foregroundColor(Color(UIColor.govUK.text.link))
        }
    }
}

extension LocalAuthorityPostcodeEntryView: TrackableScreen {
    var trackingTitle: String? { "What is your postcode" }
    var trackingName: String { "What is your postcode" }
}
