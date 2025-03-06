import SwiftUI
import UIComponents
import GOVKit

struct SettingsView<T: SettingsViewModelInterface>: View {
    @StateObject var viewModel: T
    @Namespace var topID

    init(viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color(UIColor.govUK.fills.surfaceBackground)
                .ignoresSafeArea()
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        EmptyView()
                            .id(topID)
                        GroupedList(
                            content: viewModel.listContent,
                            backgroundColor: UIColor.govUK.fills.surfaceBackground
                        )
                        .padding(.top, 8)
                    }.alert(isPresented: $viewModel.displayNotificationSettingsAlert) {
                        Alert(title: Text(viewModel.notificationSettingsAlertTitle),
                              message: Text(viewModel.notificationSettingsAlertBody),
                              primaryButton: .destructive(
                                Text(viewModel.notificationAlertButtonTitle)) {
                            viewModel.handleNotificationAlertAction()
                        }, secondaryButton: .cancel())
                    }
                    .onChange(of: viewModel.scrollToTop) { shouldScroll in
                        if shouldScroll {
                            withAnimation {
                                proxy.scrollTo(topID, anchor: .top)
                            }
                            viewModel.scrollToTop = false
                        }
                    }
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
