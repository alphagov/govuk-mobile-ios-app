import Foundation
import SwiftUI

import Lottie
import UIComponents

protocol OnboardingViewModel {
    var animationName: String { get }
    var title: String { get }
    var body: String { get }
    var primaryButtonViewModel: GOVUKButton.ButtonViewModel { get }
    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel { get }
}

struct OnboardingView: View {
    let viewModel: OnboardingViewModel

    var body: some View {
        VStack {
            bouncableScrollView
            VStack {
                SwiftUIButton(
                    .primary,
                    viewModel: viewModel.primaryButtonViewModel
                )

                SwiftUIButton(
                    .secondary,
                    viewModel: viewModel.secondaryButtonViewModel
                )
            }
            .padding(.horizontal, 16)
        }
    }

    private var bouncableScrollView: some View {
        if #available(iOS 16.4, *) {
            return scrollView
                    .scrollBounceBehavior(.basedOnSize)
        } else {
            return scrollView
        }
    }

    private var scrollView: some View {
        ScrollView(.vertical) {
            VStack {
                imageContainer
                VStack {
                    Text(viewModel.title)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .accessibilityLabel(Text(viewModel.title))
                        .padding(.top, 53)
                        .padding([.trailing, .leading], 16)
                    Text(viewModel.body)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                        .multilineTextAlignment(.center)
                        .accessibilityLabel(Text(viewModel.body))
                        .padding([.top, .leading, .trailing], 16)
                }.accessibilityElement(children: .combine)
                Spacer()
            }
        }
        .ignoresSafeArea()
    }

    private var imageContainer: some View {
        VStack {
            Spacer(minLength: 80)
            LottieView(animation: .named(viewModel.animationName))
                .playing()
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding([.bottom])
            Spacer(minLength: 40)
        }
    }
}
