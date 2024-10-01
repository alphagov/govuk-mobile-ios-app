import UIKit
import UIComponents

class SearchErrorView: UIView {
    var errorLink: String?

    lazy var errorTitle: UILabel = {
        let localLabel = UILabel()
        localLabel.translatesAutoresizingMaskIntoConstraints = false
        localLabel.font = UIFont.govUK.bodySemibold
        localLabel.textColor = UIColor.govUK.text.primary
        localLabel.textAlignment = .center
        localLabel.adjustsFontForContentSizeCategory = true
        localLabel.lineBreakMode = .byWordWrapping
        localLabel.numberOfLines = 0

        return localLabel
    }()

    lazy var errorDescription: UILabel = {
        let localLabel = UILabel()
        localLabel.translatesAutoresizingMaskIntoConstraints = false
        localLabel.lineBreakMode = .byWordWrapping
        localLabel.numberOfLines = 0
        localLabel.font = UIFont.govUK.body
        localLabel.textColor = UIColor.govUK.text.primary
        localLabel.textAlignment = .center
        localLabel.adjustsFontForContentSizeCategory = true

        return localLabel
    }()

    lazy var errorLinkButton: GOVUKButton = {
        let localButton = GOVUKButton(.secondary)
        localButton.translatesAutoresizingMaskIntoConstraints = false

        localButton.accessibilityTraits = .link
        localButton.accessibilityHint = String.common.localized("openWebLinkHint")

        return localButton
    }()

    init() {
        super.init(frame: .zero)

        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String? = nil,
                   errorDesc: String? = nil,
                   linkText: String? = nil,
                   accessibilityLinkText: String? = nil,
                   link: String? = nil) {
        errorTitle.text = title
        errorDescription.text = errorDesc
        errorLink = link

        guard link != nil
        else { return errorLinkButton.isHidden = true }

        var errorLinkButtonButtonViewModel: GOVUKButton.ButtonViewModel {
            .init(
                localisedTitle: linkText ?? "",
                action: { [weak self] in
                    self?.errorButtonPressed()
                }
            )
        }
        errorLinkButton.viewModel = errorLinkButtonButtonViewModel
        errorLinkButton.accessibilityLabel = accessibilityLinkText
    }

    private func configureUI() {
        backgroundColor = UIColor.govUK.fills.surfaceModal

        addSubview(errorTitle)
        addSubview(errorDescription)
        addSubview(errorLinkButton)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            errorTitle.topAnchor.constraint(equalTo: topAnchor),
            errorTitle.leftAnchor.constraint(equalTo: leftAnchor),
            errorTitle.rightAnchor.constraint(equalTo: rightAnchor),

            errorDescription.topAnchor.constraint(
                equalTo: errorTitle.bottomAnchor,
                constant: 8
            ),
            errorDescription.leftAnchor.constraint(equalTo: leftAnchor),
            errorDescription.rightAnchor.constraint(equalTo: rightAnchor),

            errorLinkButton.topAnchor.constraint(equalTo: errorDescription.bottomAnchor),
            errorLinkButton.leftAnchor.constraint(equalTo: leftAnchor),
            errorLinkButton.rightAnchor.constraint(equalTo: rightAnchor),
            errorLinkButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc
    private func errorButtonPressed() {
        guard let errorLink = errorLink
        else { return }

        UIApplication.shared.open(URL(string: errorLink)!)
    }
}
