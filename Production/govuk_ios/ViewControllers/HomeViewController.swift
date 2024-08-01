import Foundation
import UIKit

class HomeViewController: BaseViewController,
                          UIScrollViewDelegate {
    private lazy var sectionViews: [UIView] = []
    private lazy var navigationBar: HomeNavigationBar = {
        let localView = HomeNavigationBar()
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        scrollView.delegate = self
        dump(scrollView)
    }

    private func configureUI() {
        view.backgroundColor = UIColor.govUK.fills.surfaceBackground
        view.addSubview(scrollView)
        view.addSubview(navigationBar)
        addSections()
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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        sectionViews.forEach {
            $0.layer.borderColor = UIColor.secondaryBorder.cgColor
        }
    }

    private func addSections() {
        for section in viewModel.sections {
            let sectionView = sectionView(
                borderColor: section.borderColor,
                backgroundColor: section.backgroundColor
            )
            let sectionTitleLabel = sectionTitleLabel(
                title: section.title
            )

            sectionView.addSubview(sectionTitleLabel)
            stackView.addArrangedSubview(sectionView)
            sectionViews.append(sectionView)

            sectionView.heightAnchor.constraint(
                equalToConstant: 200
            ).isActive = true
            sectionTitleLabel.topAnchor.constraint(
                equalTo: sectionView.topAnchor,
                constant: 15
            ).isActive = true
            sectionTitleLabel.centerXAnchor.constraint(
                equalTo: sectionView.centerXAnchor
            ).isActive = true

            if section.link != nil {
                let linkLabel = UILabel()
                sectionView.addSubview(linkLabel)
                linkLabel.translatesAutoresizingMaskIntoConstraints = false
                linkLabel.text = section.link!["text"]
                linkLabel.textColor = section.linkColor
                linkLabel.font = UIFont.systemFont(ofSize: 18)
                linkLabel.topAnchor.constraint(
                    equalTo: sectionTitleLabel.topAnchor,
                    constant: 30
                ).isActive = true
                linkLabel.centerXAnchor.constraint(
                    equalTo: sectionView.centerXAnchor
                ).isActive = true
            }
        }
    }

    private func sectionTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }

    private func sectionView(borderColor: CGColor, backgroundColor: UIColor) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.layer.borderColor = borderColor
        view.backgroundColor = backgroundColor
        return view
    }
}
