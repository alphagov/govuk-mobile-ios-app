import Foundation
import UIKit

class HomeViewController: BaseViewController, UIScrollViewDelegate {
    lazy var sectionViews: [UIView] = []
    lazy var originalScrollOffset = scrollView.contentOffset.y
    lazy var logoImageView: UIImageView = {
        let logo = UIImage(named: "logo")
        let uiImageView = UIImageView(image: logo)
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        return uiImageView
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset.top = logoImageView.frame.size.height
        return scrollView
    }()
    lazy var borderView: UIView = {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.layer.borderColor = UIColor.secondaryBorder.cgColor
        border.layer.borderWidth = 1
        border.isHidden = true
        return border
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self

        addElements()
        setupConstraints()

        view.backgroundColor = UIColor.primaryBackground
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        resizeLogo(scrollOffset: scrollOffset)
    }

    func resizeLogo(scrollOffset: Double) {
        let animationMaxBound = originalScrollOffset + 30
        let animationRange = originalScrollOffset...animationMaxBound

        if scrollOffset >= 0 {
            borderView.isHidden = false
        } else {
            borderView.isHidden = true
        }

        if animationRange.contains(scrollOffset) {
            scaleLogo(scrollOffset: scrollOffset,
                      animationMaxBound: animationMaxBound)
        } else if scrollOffset <= originalScrollOffset {
            logoImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        } else {
            scaleLogo(scrollOffset: animationMaxBound,
                      animationMaxBound: animationMaxBound)
        }
    }

    func scaleLogo(scrollOffset: Double, animationMaxBound: Double) {
        let animationRangeArray = [Int](Int(originalScrollOffset)...Int(animationMaxBound))
        let scaleValue = animationRangeArray.firstIndex(of: Int(scrollOffset))
        let scaleMultiplier = 0.7
        let scaleBy = 1 - ((Double(scaleValue!) / 100.0) * scaleMultiplier)

        logoImageView.transform = CGAffineTransform(scaleX: scaleBy, y: scaleBy)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        for view in sectionViews {
            view.layer.borderColor = UIColor.secondaryBorder.cgColor
        }
    }

    func addElements() {
        view.addSubview(logoImageView)
        view.addSubview(borderView)
        view.addSubview(scrollView)

        for _ in 1...6 {
            let sectionView = sectionView()
            let sectionLabel = sectionLabel()

            sectionView.addSubview(sectionLabel)
            stackView.addArrangedSubview(sectionView)
            sectionViews.append(sectionView)

            sectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
            sectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            sectionLabel.topAnchor.constraint(equalTo: sectionView.topAnchor,
                                              constant: 15).isActive = true
            sectionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
    }

    func sectionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Scrollable content"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }

    func sectionView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.secondaryBorder.cgColor
        view.backgroundColor = .secondaryBackground
        return view
    }

    func setupConstraints() {
        let safeGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            borderView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor,
                                            constant: 5),
            borderView.heightAnchor.constraint(equalToConstant: 0.33),
            borderView.widthAnchor.constraint(equalTo: view.widthAnchor),

            scrollView.topAnchor.constraint(equalTo: borderView.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}
