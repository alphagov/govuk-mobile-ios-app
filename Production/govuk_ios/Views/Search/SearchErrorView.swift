import UIKit

class SearchErrorView: UIView {
    var errorLink: String?

    lazy var errorTitle: UILabel = {
        let localLabel = UILabel()
        localLabel.translatesAutoresizingMaskIntoConstraints = false
        localLabel.font = UIFont.govUK.bodySemibold
        localLabel.textColor = UIColor.govUK.text.primary
        localLabel.textAlignment = .center
        localLabel.adjustsFontForContentSizeCategory = true

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

    lazy var errorLinkButton: UIButton = {
        var button = UIButton()
        let image = UIImage(systemName: "arrow.up.right")

        button.translatesAutoresizingMaskIntoConstraints = false

        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.govUK.text.link, for: .normal)
        button.titleLabel?.font = UIFont.govUK.body

        button.setImage(image, for: .normal)
        button.imageView?.clipsToBounds = true
        button.imageView?.tintColor = UIColor.govUK.text.link
        button.imageEdgeInsets.left = 8

        button.contentHorizontalAlignment = .center
        button.semanticContentAttribute = .forceRightToLeft

        button.addTarget(
            self,
            action: #selector(errorButtonPressed),
            for: .touchUpInside
        )

        return button
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
                   link: String? = nil) {
        errorTitle.text = title
        errorDescription.text = errorDesc
        errorLinkButton.setTitle(linkText, for: .normal)
        errorLink = link

        if link == nil {
            errorLinkButton.isHidden = true
        }
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

            errorLinkButton.topAnchor.constraint(
                equalTo: errorDescription.bottomAnchor,
                constant: 16
            ),
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
