import Foundation
import UIKit
import UIComponents
import GOVKit

class HomeContentViewController: BaseViewController,
                                 UIScrollViewDelegate {
    private let viewModel: HomeViewModel

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

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(analyticsService: viewModel.analyticsService)
        title = String.home.localized("pageTitle")
    }

    @MainActor
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
        scrollView.backgroundColor = UIColor.govUK.fills.surfaceBackground
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        addWidgets()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor)
        ])
    }

    private func addWidgets() {
        viewModel.widgets.lazy.forEach(stackView.addArrangedSubview)
        if let lastWidget = stackView.arrangedSubviews.last {
            stackView.setCustomSpacing(32, after: lastWidget)
        }
        stackView.addArrangedSubview(crownLogoImageView)
    }
}

extension HomeContentViewController: TrackableScreen {
    var trackingName: String { "Homepage" }
    var trackingTitle: String? { "Homepage" }
}
