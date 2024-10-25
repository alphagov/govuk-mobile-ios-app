import SwiftUI
import UIComponents

struct SettingsView<T: SettingsViewModelInterface>: View {
    @StateObject var viewModel: T

    init(viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color(UIColor.govUK.fills.surfaceBackground)
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    GroupedList(
                        content: viewModel.listContent,
                        backgroundColor: UIColor.govUK.fills.surfaceBackground
                    )
                    .padding(.top, 16)
                }
            }
        }
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private func descripitonView(description: String) -> some View {
        HStack {
            Text(description)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 18)
            Spacer()
        }
    }
}

extension SettingsView: TrackableScreen {
    var trackingTitle: String? { viewModel.title }
    var trackingName: String { "Settings" }
}
