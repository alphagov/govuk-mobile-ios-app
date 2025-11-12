import SwiftUI
import GOVKit
import UIComponents

struct TouchIdSettingsView: View {
    @StateObject var viewModel: LocalAuthenticationSettingsViewModel

    init(viewModel: LocalAuthenticationSettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Toggle(isOn: $viewModel.touchIdEnabled) {
                        Text(viewModel.buttonTitle)
                            .foregroundColor(
                                Color(
                                    UIColor.govUK.text.primary
                                )
                            )
                    }
                    .toggleStyle(
                        SwitchToggleStyle(
                            tint: (Color(UIColor.govUK.fills.surfaceToggleSelected))
                        )
                    )
                    .onChange(of: viewModel.touchIdEnabled) { enabled in
                        viewModel.touchIdToggleAction(enabled: enabled)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 11)
                    .background(Color(UIColor.govUK.fills.surfaceList))
                    .roundedBorder()
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

extension TouchIdSettingsView: TrackableScreen {
    var trackingTitle: String? { "Touch ID settings" }
    var trackingName: String { "Touch ID settings" }
}
