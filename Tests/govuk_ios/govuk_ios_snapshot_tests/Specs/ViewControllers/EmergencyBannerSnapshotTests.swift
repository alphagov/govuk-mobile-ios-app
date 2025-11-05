import Foundation
import UIKit
import SwiftUI
import CoreData
import GOVKit

@testable import govuk_ios

class EmergencyBannerSnapshotTests: SnapshotTestCase {

    func test_notableDeath_light_no_link_rendersCorrectly() {
        let model = EmergencyBannerWidgetViewModel(
            banner: EmergencyBanner(
                id: "1",
                title: "His Majesty King Henry VIII",
                body: "1491 - 1547",
                link: nil,
                type: "notable-death",
                allowsDismissal: true
            ),
            sortPriority: 1,
            openURLAction: { _ in },
            dismiss: { }
        )
        let view = EmergencyBannerWidgetView(viewModel: model)
        let viewController = HostingViewController(
            rootView: view,
            navigationBarHidden: true
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_notableDeath_dark_link_rendersCorrectly() {
        let model = EmergencyBannerWidgetViewModel(
            banner: EmergencyBanner(
                id: "1",
                title: "His Majesty King Henry VIII",
                body: "1491 - 1547",
                link: EmergencyBanner.Link(
                    title: "More information",
                    url: URL(string: "https://example.com")!
                ),
                type: "notable-death",
                allowsDismissal: true
            ),
            sortPriority: 1,
            openURLAction: { _ in },
            dismiss: { }
        )
        let view = EmergencyBannerWidgetView(viewModel: model)
        let viewController = HostingViewController(
            rootView: view,
            navigationBarHidden: true
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark,
            navBarHidden: true
        )
    }

    func test_nationalEmergency_dark_link_rendersCorrectly() {
        let model = EmergencyBannerWidgetViewModel(
            banner: EmergencyBanner(
                id: "1",
                title: "National emergency",
                body: "This is a level 1 incident",
                link: EmergencyBanner.Link(
                    title: "More information",
                    url: URL(string: "https://example.com")!
                ),
                type: "national-emergency",
                allowsDismissal: true
            ),
            sortPriority: 1,
            openURLAction: { _ in },
            dismiss: { }
        )
        let view = EmergencyBannerWidgetView(viewModel: model)
        let viewController = HostingViewController(
            rootView: view,
            navigationBarHidden: true
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark,
            navBarHidden: true
        )
    }

    func test_nationalEmergency_light_link_noDismissal_rendersCorrectly() {
        let model = EmergencyBannerWidgetViewModel(
            banner: EmergencyBanner(
                id: "1",
                title: "National emergency",
                body: "This is a level 1 incident",
                link: EmergencyBanner.Link(
                    title: "More information",
                    url: URL(string: "https://example.com")!
                ),
                type: "national-emergency",
                allowsDismissal: false
            ),
            sortPriority: 1,
            openURLAction: { _ in },
            dismiss: { }
        )
        let view = EmergencyBannerWidgetView(viewModel: model)
        let viewController = HostingViewController(
            rootView: view,
            navigationBarHidden: true
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_localEmergency_link_rendersCorrectly() {
        let model = EmergencyBannerWidgetViewModel(
            banner: EmergencyBanner(
                id: "1",
                title: "Local emergency",
                body: "This is a level 2 incident. If this was a level 1 incident, it would be red",
                link: EmergencyBanner.Link(
                    title: "More information",
                    url: URL(string: "https://example.com")!
                ),
                type: "local-emergency",
                allowsDismissal: true
            ),
            sortPriority: 1,
            openURLAction: { _ in },
            dismiss: { }
        )
        let view = EmergencyBannerWidgetView(viewModel: model)
        let viewController = HostingViewController(
            rootView: view,
            navigationBarHidden: true
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_information_link_light_rendersCorrectly() {
        let model = EmergencyBannerWidgetViewModel(
            banner: EmergencyBanner(
                id: "1",
                title: "Emergency alerts",
                body: "Test on Sunday 7 September, 3pm",
                link: EmergencyBanner.Link(
                    title: "More information",
                    url: URL(string: "https://example.com")!
                ),
                type: "information",
                allowsDismissal: true
            ),
            sortPriority: 1,
            openURLAction: { _ in },
            dismiss: { }
        )
        let view = EmergencyBannerWidgetView(viewModel: model)
        let viewController = HostingViewController(
            rootView: view,
            navigationBarHidden: true
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_information_link_dark_rendersCorrectly() {
        let model = EmergencyBannerWidgetViewModel(
            banner: EmergencyBanner(
                id: "1",
                title: "Emergency alerts",
                body: "Test on Sunday 7 September, 3pm",
                link: EmergencyBanner.Link(
                    title: "More information",
                    url: URL(string: "https://example.com")!
                ),
                type: "information",
                allowsDismissal: true
            ),
            sortPriority: 1,
            openURLAction: { _ in },
            dismiss: { }
        )
        let view = EmergencyBannerWidgetView(viewModel: model)
        let viewController = HostingViewController(
            rootView: view,
            navigationBarHidden: true
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark,
            navBarHidden: true
        )
    }

    func test_information_link_no_title_light_rendersCorrectly() {
        let model = EmergencyBannerWidgetViewModel(
            banner: EmergencyBanner(
                id: "1",
                title: nil,
                body: "We are testing the UK’s Emergency Alerts system on Sunday 7 September at 3pm.",
                link: EmergencyBanner.Link(
                    title: "More information",
                    url: URL(string: "https://example.com")!
                ),
                type: "information",
                allowsDismissal: true
            ),
            sortPriority: 1,
            openURLAction: { _ in },
            dismiss: { }
        )
        let view = EmergencyBannerWidgetView(viewModel: model)
        let viewController = HostingViewController(
            rootView: view,
            navigationBarHidden: true
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }


}


