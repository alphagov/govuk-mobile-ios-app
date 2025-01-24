import UIKit
import UIComponents

final public class SearchModalButton: UIButton {
    init() {
        super.init(frame: .zero)
        self.configuration = UIButton.Configuration.plain()

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        guard let width = titleLabel?.frame.width else { return }
        titleLabel?.preferredMaxLayoutWidth = width
    }

    public override var intrinsicContentSize: CGSize {
        let titlesize = titleLabel?.intrinsicContentSize ?? .zero

        guard let leftContentEdgeInsets = configuration?.contentInsets.leading,
              let rightContentEdgeInsets = configuration?.contentInsets.trailing,
              let topContentEdgeInsets = configuration?.contentInsets.top,
              let bottomContentEdgeInsets = configuration?.contentInsets.bottom
        else { return .zero }

        let widthEdgeInserts = leftContentEdgeInsets + rightContentEdgeInsets
        let heightEdgeInserts = topContentEdgeInsets + bottomContentEdgeInsets

        return CGSize(
            width: titlesize.width + widthEdgeInserts,
            height: titlesize.height + heightEdgeInserts
        )
    }

    private func configureUI() {
        let image = UIImage(
            systemName: "magnifyingglass"
        )
        adjustsImageSizeForAccessibilityContentSizeCategory = true

        let buttonTitle = String.home.localized("searchButtonTitle")
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.adjustsFontForContentSizeCategory = true
        setTitle(buttonTitle, for: .normal)
        setTitleColor(GOVUKColors.text.secondary, for: .normal)
        titleLabel?.font = UIFont.govUK.body
        tintColor = GOVUKColors.text.secondary
        let leftTitleEdgeInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 13,
            bottom: 0,
            trailing: 0
        ).leading
        configuration?.titlePadding = leftTitleEdgeInsets
        setImage(image, for: .normal)
        imageView?.clipsToBounds = true
        let leftImageEdgeInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 0
        ).leading
        configuration?.imagePadding = leftImageEdgeInsets
        contentHorizontalAlignment = .left
        backgroundColor = GOVUKColors.fills.surfaceSearchBox
        layer.cornerRadius = 10
    }
}
