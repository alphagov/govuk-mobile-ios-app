import UIKit
import CoreData
import GOVKit
import RecentActivity
import Factory
import UIComponents

class TestViewController: UIViewController,
                          AnalyticsProviding {
    var analyticsService: (any AnalyticsServiceInterface)?

    private let coreData: CoreDataRepository

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.govUK.bodySemibold
        label.textColor = UIColor.govUK.text.primary
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.text = self.fetchLatest()
        return label
    }()

    private lazy var actionButtonViewModel: GOVUKButton.ButtonViewModel = {
        .init(
            localisedTitle: "Click me",
            action: {
                let item = WidgetItem(context: self.coreData.viewContext)
                item.name = Date().formatted()
                item.timestamp = Date()
                self.titleLabel.text = item.name
                _ = try! self.coreData.viewContext.save()
                self.analyticsService?.track(event: .buttonFunction(
                    text: "Click me",
                    section: "test",
                    action: "tap")
                )
            }
        )
    }()

    private lazy var actionButton: GOVUKButton = {
        let button = GOVUKButton(
            .secondary,
            viewModel: actionButtonViewModel)
        return button
    }()

    init() {
        coreData = TestWidgetRepository().coreData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Test"
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(actionButton)
        view.addSubview(stackView)
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backButtonTitle = "Test"
        navigationController?.isNavigationBarHidden = false
        self.view.backgroundColor = UIColor.govUK.fills.surfaceBackground
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        self.analyticsService?.track(screen: self)
    }

    private func fetchLatest() -> String {
        let context = coreData.viewContext
        let fetchRequest: NSFetchRequest<WidgetItem> = WidgetItem.fetchRequest()
        return (try? context.fetch(fetchRequest).last?.name) ?? "No Data"
    }
}

extension TestViewController: TrackableScreen {
    var trackingName: String {
        "TestViewController"
    }
}
