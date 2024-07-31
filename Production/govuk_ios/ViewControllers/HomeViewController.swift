import Foundation
import UIKit

class HomeViewController: BaseViewController,
                          UIScrollViewDelegate {
    private lazy var sectionViews: [UIView] = []
    private lazy var originalScrollOffset = scrollView.contentOffset.y
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
        scrollView.contentInset.top = 96
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
        scrollView.delegate = self

        configureUI()
        configureConstraints()
    }

    private func configureUI() {
        view.backgroundColor = UIColor.govUK.fills.surfaceBackground
        view.addSubview(scrollView)
        view.addSubview(navigationBar)
//        view.addSubview(logoImageView)
//        view.addSubview(headerBorderView)
        addSections()
    }

    private func configureConstraints() {
        let constant = navigationBar.heightAnchor.constraint(equalToConstant: 80)
        constant.priority = .defaultLow
        NSLayoutConstraint.activate([
//            logoImageView.topAnchor.constraint(
//                equalTo: view.safeAreaLayoutGuide.topAnchor,
//                constant: 20
//            ),
//            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            headerBorderView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor,
//                                                  constant: 5),
//            headerBorderView.widthAnchor.constraint(equalTo: view.widthAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            navigationBar.heightAnchor.constraint(lessThanOrEqualToConstant: 80),
            constant,

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

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let scrollOffset = scrollView.contentOffset.y
//        animateLogo(scrollOffset: scrollOffset)
//    }
//
//    private func animateLogo(scrollOffset: Double) {
//        let animationMaxBound = originalScrollOffset + 30
//        let animationRange = originalScrollOffset...animationMaxBound
//
//        if scrollOffset >= 0 {
//            headerBorderView.isHidden = false
//        } else {
//            headerBorderView.isHidden = true
//        }
//
//        if animationRange.contains(scrollOffset) {
//            scaleLogo(scrollOffset: scrollOffset,
//                      animationMaxBound: animationMaxBound)
//        } else if scrollOffset <= originalScrollOffset {
//            logoImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
//        } else {
//            scaleLogo(scrollOffset: animationMaxBound,
//                      animationMaxBound: animationMaxBound)
//        }
//    }

//    private func scaleLogo(scrollOffset: Double, animationMaxBound: Double) {
//        let animationRangeArray = [Int](Int(originalScrollOffset)...Int(animationMaxBound))
//        let scaleValue = animationRangeArray.firstIndex(of: Int(scrollOffset))
//        let scaleMultiplier = 0.7
//        let scaleBy = 1 - ((Double(scaleValue!) / 100.0) * scaleMultiplier)
//
//        logoImageView.transform = CGAffineTransform(scaleX: scaleBy, y: scaleBy)
//    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        for view in sectionViews {
            view.layer.borderColor = UIColor.secondaryBorder.cgColor
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

            sectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            sectionTitleLabel.topAnchor.constraint(equalTo: sectionView.topAnchor,
                                                   constant: 15).isActive = true
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
                linkLabel.topAnchor.constraint(equalTo: sectionTitleLabel.topAnchor,
                                               constant: 30).isActive = true
                linkLabel.centerXAnchor.constraint(
                    equalTo: sectionView.centerXAnchor).isActive = true
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
