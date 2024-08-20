import Foundation
import UIKit
import UIComponents

class SettingsViewController: BaseViewController,
                              TrackableScreen {
    var trackingName: String { "settingsscreen" }

    private var viewModel: SettingsViewModel

    let scrollview = UIScrollView(frame: .zero)

    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.govUK.fills.surfaceBackground

        title = "Settings"

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true

        scrollview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollview)

        addContent()

        constraints()
    }

    private func addContent() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill

        for index in 1..<30 {
            let label = UILabel()
            label.text = "temporary content \(index)"
            label.font = UIFont.govUK.largeTitle
            label.adjustsFontForContentSizeCategory = true

            stack.addArrangedSubview(label)
        }
        scrollview.addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor, constant: -16),
            stack.heightAnchor.constraint(equalTo: scrollview.contentLayoutGuide.heightAnchor)
        ])
    }

    private func constraints() {
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: scrollview.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor),
            scrollview.contentLayoutGuide
                .leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollview.contentLayoutGuide
                .trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
