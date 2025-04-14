import Foundation
import UIKit
import Testing

@testable import GOVKit

@Suite
struct String_ExtensionsTests {
    @Test(.disabled("Disabled due to bundle loading issues"))
    func common_hasCorrectValues() {
        let sut = String.common
        #expect(sut.tableName == "Common")
    }
}
