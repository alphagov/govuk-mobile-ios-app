import UIKit
import Foundation

import Lottie

class LaunchViewController: BaseViewController {
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)

    private var animation: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
//        configureConstraints()
//        activityIndicator.startAnimating()

    }

    private func configureUI() {
        view.backgroundColor = .splashScreenBlue
//        activityIndicator.color = .white
//        view.addSubview(activityIndicator)
        configAnimation()
    }

    private func configureConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func configAnimation() {
        animation = LottieAnimationView(name: "exampleAnimation")

        let red = LottieColor(r: (251/255), g: (0/255), b: (0/255), a: 1)
        let redColorValueProvider = ColorValueProvider(red)

        let blue = LottieColor(r: (0/255), g: (0/255), b: (255/255), a: 1)
        let blueColorValueProvider = ColorValueProvider(blue)

        // Set color value provider to animation view
        let keyPath = AnimationKeypath(keypath: "**.Group 1.Fill 1.Color")
        print(keyPath)
        animation?.setValueProvider(redColorValueProvider, keypath: keyPath)

        animation?.frame = view.bounds
        animation?.contentMode = .scaleAspectFit
        animation?.loopMode = .loop
        animation?.animationSpeed = 1
        if let animation {
            view.addSubview(animation)
        }
        animation?.play()
    }
}
