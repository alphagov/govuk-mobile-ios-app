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
                    .padding(.top, 8)
                }
            }
        }
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }
}

extension SettingsView: TrackableScreen {
    var trackingTitle: String? { viewModel.title }
    var trackingName: String { "Settings" }
}
