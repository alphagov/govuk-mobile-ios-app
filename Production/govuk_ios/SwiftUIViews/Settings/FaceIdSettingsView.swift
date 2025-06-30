import SwiftUI
import GOVKit

struct FaceIdSettingsView: View {
    @StateObject var viewModel: LocalAuthenticationSettingsViewModel

    init(viewModel: LocalAuthenticationSettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Button {
                        viewModel.faceIdButtonAction()
                    } label: {
                        HStack {
                            Text(viewModel.buttonTitle)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(
                                    Color(
                                        UIColor.govUK.text.primary
                                    )
                                )
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(
                                    Color(
                                        UIColor.govUK.text.trailingIcon
                                    )
                                )
                                .font(Font.govUK.bodySemibold)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 11)
                        .background(Color(UIColor.govUK.fills.surfaceList))
                        .roundedBorder()
                    }
                    .alert(isPresented: $viewModel.showSettingsAlert) {
                        Alert(
                            title: Text(
                                String.settings.localized("localAuthenticationSettingsAlertTitle")
                            ),
                            message: nil,
                            primaryButton: .default(
                                Text(
                                    String.common.localized("continue")
                                ),
                                action: {
                                    viewModel.openSettings()
                                }
                            ),
                            secondaryButton: .cancel()
                        )
                    }
                    ForEach(viewModel.body.split(separator: "\n\n"), id: \.self) { paragraph in
                        Text(paragraph).font(Font.govUK.body)
                    }
                }
                .padding(16)
            }
            .accessibilityElement(children: .contain)
        }
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }
}

extension FaceIdSettingsView: TrackableScreen {
    var trackingTitle: String? { "Face ID settings" }
    var trackingName: String { "Face ID settings" }
}
