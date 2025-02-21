import Foundation
import UIKit
import GOVKit

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
    private let crownLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "crownLogo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(analyticsService: viewModel.analyticsService)
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
        view.backgroundColor = UIColor.govUK.fills.surfaceHomeHeaderBackground
        scrollView.backgroundColor = UIColor.govUK.fills.surfaceBackground
        view.addSubview(scrollView)
        view.addSubview(navigationBar)
        scrollView.addSubview(stackView)
        addWidgets()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor)
        ])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationBar.handleScroll(scrollView: scrollView)
    }

    private func addWidgets() {
        viewModel.widgets.lazy.forEach(stackView.addArrangedSubview)
        if let lastWidget = stackView.arrangedSubviews.last {
            stackView.setCustomSpacing(32, after: lastWidget)
        }
        stackView.addArrangedSubview(crownLogoImageView)
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
