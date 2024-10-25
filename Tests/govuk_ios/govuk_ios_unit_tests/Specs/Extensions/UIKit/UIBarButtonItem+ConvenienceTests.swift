import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct UIBarButtonItem_Convenience {
    @Test
    func selectAll_returnsExpectedResult() {
        let result = UIBarButtonItem.selectAll(action: { _ in } )
        #expect(result.title == "Select all")
    }

    @Test
    func deselectAll_returnsExpectedResult() {
        let result = UIBarButtonItem.deselectAll(action: { _ in } )
        #expect(result.title == "Deselect all")
    }

    @Test
    func remove_returnsExpectedResult() {
        let result = UIBarButtonItem.remove(action: { _ in } )
        #expect(result.title == "Remove")
    }
}
