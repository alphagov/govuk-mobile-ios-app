import Foundation
import SwiftUI
import UIComponents
import GOVKit

struct NotificationSettingsView: View {
    @StateObject private var viewModel: NotificationSettingsViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: NotificationSettingsViewModel,
         analyticsService: AnalyticsServiceInterface) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }


    var body: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .loaded(let slide):
            VStack(spacing: 0) {
                    ScrollView {
                        VStack {
                            if verticalSizeClass == .regular {
                                Spacer(minLength: 32)
                            }
                            if verticalSizeClass != .compact {
                                slide.lottieView
                                    .playbackMode(.playing(.fromProgress(
                                        0,
                                        toProgress: 1,
                                        loopMode: .playOnce
                                    )))
                                    .scaledToFit()
                                    .frame(width: 290, height: 290)
                                    .padding([.bottom])
                            }
                            Text(slide.title)
                                .foregroundColor(Color(UIColor.govUK.text.primary))
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .accessibilityLabel(Text(slide.title))
                                .padding(.top, verticalSizeClass == .compact ? 32 : 0)
                                .padding([.trailing, .leading], 16)
                                .accessibilityAddTraits(.isHeader)
                                .accessibilitySortPriority(1)
                            Text(slide.body)
                                .foregroundColor(Color(UIColor.govUK.text.primary))
                                .multilineTextAlignment(.center)
                                .accessibilityLabel(Text(slide.body))
                                .padding([.top, .leading, .trailing], 16)
                                .accessibilitySortPriority(0)
                        }.accessibilityElement(children: .contain)
                    }
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
                                viewModel: viewModel.primaryButtonViewModel
                            )
                            .accessibilityHint("")
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
    }
}
