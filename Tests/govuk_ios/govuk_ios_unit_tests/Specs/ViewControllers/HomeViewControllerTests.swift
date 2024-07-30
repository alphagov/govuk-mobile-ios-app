import UIKit
import Foundation
import XCTest

@testable import govuk_ios

class HomeViewControllerTests: XCTestCase {
    func test_logoImageView_containsLogoImage() {
        let viewModel = HomeViewModel()
        let subject = HomeViewController(viewModel: viewModel)
        XCTAssertEqual(UIImage.homeLogo, subject.logoImageView.image)
    }
    
    func test_scrollView_isConfiguredCorrectly() {
        let viewModel = HomeViewModel()
        let subject = HomeViewController(viewModel: viewModel)
        let logo = subject.logoImageView
        XCTAssertFalse(subject.scrollView.showsVerticalScrollIndicator)
        XCTAssertEqual(subject.scrollView.contentInset.top, logo.frame.size.height)
    }
    
    func test_stackView_isConfiguredCorrectly() {
        let viewModel = HomeViewModel()
        let subject = HomeViewController(viewModel: viewModel)
        XCTAssertEqual(subject.stackView.axis, .vertical)
    }
    
    func test_borderView_isConfiguredCorrectly() {
        let viewModel = HomeViewModel()
        let subject = HomeViewController(viewModel: viewModel)
        XCTAssertTrue(subject.headerBorderView.isHidden)
        XCTAssertEqual(subject.headerBorderView.layer.borderColor, UIColor.primaryDivider.cgColor)
        XCTAssertEqual(subject.headerBorderView.layer.borderWidth, 1)
    }
    
    func test_stackView_hasCorrectNumberOfSectionViews() {
        let viewModel = HomeViewModel()
        let subject = HomeViewController(viewModel: viewModel)
        _ = subject.view
        XCTAssertEqual(subject.stackView.subviews.count, 6)
    }
}
