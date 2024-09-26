import Foundation
import SwiftUI
import UIKit
import UIComponents

class SettingsViewController: BaseViewController,
                              TrackableScreen {
    var trackingName: String { "Settings" }

    private var viewModel: SettingsViewModelInterface
    private let scrollview = UIScrollView(frame: .zero)
    private let backgroundColor = UIColor.govUK.fills.surfaceBackground

    private lazy var contentViewController: UIViewController = {
        let settingsContentView = GroupedList(
            content: viewModel.listContent,
            backgroundColor: backgroundColor
        )
        let viewController = UIHostingController(rootView: settingsContentView)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()

    public init(viewModel: SettingsViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true

        configureUI()
        configureConstraints()
    }

    private func configureUI() {
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollview)

        addChild(contentViewController)

        scrollview.addSubview(contentViewController.view)

        contentViewController.didMove(toParent: self)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            contentViewController.view.leadingAnchor.constraint(
                equalTo: scrollview.leadingAnchor
            ),
            contentViewController.view.trailingAnchor.constraint(
                equalTo: scrollview.trailingAnchor
            ),
            contentViewController.view.topAnchor.constraint(
                equalTo: scrollview.contentLayoutGuide.topAnchor,
                constant: 10
            ),
            contentViewController.view.heightAnchor.constraint(
                lessThanOrEqualTo: scrollview.contentLayoutGuide.heightAnchor
            ),
            view.safeAreaLayoutGuide.leadingAnchor.constraint(
                equalTo: scrollview.leadingAnchor
            ),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(
                equalTo: scrollview.trailingAnchor
            ),
            view.safeAreaLayoutGuide.topAnchor.constraint(
                equalTo: scrollview.topAnchor
            ),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(
                equalTo: scrollview.bottomAnchor
            ),
            scrollview.contentLayoutGuide.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            scrollview.contentLayoutGuide.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            )
        ])
    }
}
