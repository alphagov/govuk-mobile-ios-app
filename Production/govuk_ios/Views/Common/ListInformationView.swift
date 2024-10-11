import UIKit
import UIComponents

class ListInformationView: UIView {
    private(set) var link: String?

    private lazy var titleLabel: UILabel = {
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

    private lazy var descriptionLabel: UILabel = {
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

    private lazy var linkButton: GOVUKButton = {
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
                   description: String? = nil,
                   linkText: String? = nil,
                   accessibilityLinkText: String? = nil,
                   link: String? = nil) {
        titleLabel.text = title
        descriptionLabel.text = description
        self.link = link

        linkButton.isHidden = link == nil

        linkButton.viewModel = .init(
            localisedTitle: linkText ?? "",
            action: { [weak self] in
                self?.linkButtonPressed()
            }
        )
        linkButton.accessibilityLabel = accessibilityLinkText
    }

    private func configureUI() {
        backgroundColor = UIColor.govUK.fills.surfaceModal

        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(linkButton)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),

            descriptionLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 8
            ),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor),

            linkButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            linkButton.leftAnchor.constraint(equalTo: leftAnchor),
            linkButton.rightAnchor.constraint(equalTo: rightAnchor),
            linkButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc
    private func linkButtonPressed() {
        guard let errorLink = link
        else { return }

        UIApplication.shared.open(URL(string: errorLink)!)
    }
}
