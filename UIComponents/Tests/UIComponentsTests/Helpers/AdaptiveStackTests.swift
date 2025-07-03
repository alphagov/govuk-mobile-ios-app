@testable import UIComponents
import XCTest
import SwiftUI

final class AdaptiveStackTests: XCTestCase {

    func test_body_returnsConditionalContentInOrder() {

        let sut = AdaptiveStack<EmptyView>(content: {})
        
        let reflection = Mirror(reflecting: sut.body)
        
        XCTAssertEqual(reflection.children.count, 1)
        
        let wrappedConditionalContent = reflection.children .first(where: { label, value in
            value is _ConditionalContent<HStack<EmptyView>, VStack<EmptyView>>
        })
        
        XCTAssertNotNil(wrappedConditionalContent)
        
        let conditionalContent = try? XCTUnwrap(wrappedConditionalContent?.value as? 
            _ConditionalContent<HStack<EmptyView>, VStack<EmptyView>>)
        
        XCTAssertNotNil(conditionalContent)
    }
}
