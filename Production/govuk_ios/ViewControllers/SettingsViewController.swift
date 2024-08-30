import Foundation
import SwiftUI
import UIKit
import UIComponents

class SettingsViewController: BaseViewController,
                              TrackableScreen {
    var trackingName: String { "Settings" }
    var trackingTitle: String? { viewModel.title }

    private var viewModel: SettingsViewModel
    private let scrollview = UIScrollView(frame: .zero)

    private var contentViewController: UIViewController {
        let settingsContentView = GroupedList(content: viewModel.listContent)

        return UIHostingController(rootView: settingsContentView)
    }

    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("app version: ", viewModel.appVersion)

        view.backgroundColor = UIColor.govUK.fills.surfaceBackground

        title = viewModel.title
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true

        scrollview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollview)

        configureUI()
        configureConstraints()
    }

    private func configureUI() {
        // placeholder content - will be replaced
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill

        for index in 1..<100 {
            let label = UILabel()
            label.numberOfLines = 0
            label.text = "temporary content \(index)"
            label.font = UIFont.govUK.body
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

    private func configureConstraints() {
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

        print("app version: ", viewModel.appVersion)
    }
}
