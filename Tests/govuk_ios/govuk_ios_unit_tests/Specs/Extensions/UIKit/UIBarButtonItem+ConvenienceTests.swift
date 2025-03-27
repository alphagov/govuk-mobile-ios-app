import Foundation
import UIKit
import Testing
import GOVKit

@testable import govuk_ios

@Suite
@MainActor
struct UIBarButtonItem_Convenience {
    @Test
    func selectAll_returnsExpectedResult() {
        let result = UIBarButtonItem.selectAll(action: { _ in } ) as? TopAlignedBarButtonItem
        #expect(result?.actionButton.title(for: .normal) == "Select all")
    }

    @Test
    func deselectAll_returnsExpectedResult() {
        let result = UIBarButtonItem.deselectAll(action: { _ in } ) as? TopAlignedBarButtonItem
        #expect(result?.actionButton.title(for: .normal)  == "Deselect all")
    }

    @Test
    func remove_returnsExpectedResult() {
        let result = UIBarButtonItem.remove(action: { _ in } ) as? TopAlignedBarButtonItem
        #expect(result?.actionButton.title(for: .normal)  == "Remove")
    }
}
