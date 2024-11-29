import Foundation
import UIKit

class HomeViewController: BaseViewController,
                          UIScrollViewDelegate {
    private lazy var navigationBar: NavigationBar = {
        let localView = NavigationBar()
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset.top = navigationBar.sittingHeight + 16
        scrollView.contentInset.bottom = 32
        scrollView.contentInsetAdjustmentBehavior = .always
        return scrollView
    }()

    private let viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = String.home.localized("pageTitle")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        scrollView.delegate = self
    }

    private func configureUI() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = UIColor.govUK.fills.surfaceBackground
        view.addSubview(scrollView)
        view.addSubview(navigationBar)
        scrollView.addSubview(stackView)
        addWidgets()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor)
        ])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationBar.handleScroll(scrollView: scrollView)
    }

    private func addWidgets() {
        viewModel.widgets.lazy.forEach(stackView.addArrangedSubview)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

extension HomeViewController: TrackableScreen {
    var trackingName: String { "Homepage" }
    var trackingTitle: String? { "Homepage" }
}

extension HomeViewController: ContentScrollable {
    func scrollToTop() {
        scrollView.setContentOffset(
            CGPoint(
                x: 0,
                y: -(navigationBar.sittingHeight + 16)
            ),
            animated: true)
    }
}
