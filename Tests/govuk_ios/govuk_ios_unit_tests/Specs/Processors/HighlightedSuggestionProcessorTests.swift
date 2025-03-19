import UIKit
import Testing

@testable import govuk_ios

@Suite
struct HighlightedSuggestionProcessorTests {
    let processor = SuggestionHighlighterProcessor()

    @Test
    func process_fullMatch_returnsCorrectAttributeString() {
        let result = processor.process(text: "test", suggestion: "test")

        #expect(result.string == "test")

        var effectiveRangeMatched = NSRange(location: 0, length: 0)
        let matchedAttributes = result.attributes(at: 0, effectiveRange: &effectiveRangeMatched)
        #expect(matchedAttributes[.font] as? UIFont == UIFont.govUK.body)
        #expect(effectiveRangeMatched == NSRange(location: 0, length: 4))
    }

    @Test
    func process_partialMatch_returnsCorrectAttributeString() {
        let result = processor.process(text: "pass", suggestion: "passport")

        #expect(result.string == "passport")

        var effectiveRangeMatched = NSRange(location: 0, length: 0)
        var effectiveRangeUnmatched = NSRange(location: 0, length: 0)
        let matchedAttributes = result.attributes(at: 0, effectiveRange: &effectiveRangeMatched)
        let unmatchedAttributes = result.attributes(at: 5, effectiveRange: &effectiveRangeUnmatched)
        #expect(matchedAttributes[.font] as? UIFont == UIFont.govUK.body)
        #expect(unmatchedAttributes[.font] as? UIFont == UIFont.govUK.bodySemibold)
        #expect(effectiveRangeMatched == NSRange(location: 0, length: 4))
        #expect(effectiveRangeUnmatched == NSRange(location: 4, length: 4))
    }

    @Test
    func process_noMatch_returnsCorrectAttributeString() {
        let result = processor.process(text: "xyz", suggestion: "passport")

        #expect(result.string == "passport")

        var effectiveRangeUnmatched = NSRange(location: 0, length: 0)
        let unmatchedAttributes = result.attributes(at: 0, effectiveRange: &effectiveRangeUnmatched)
        #expect(unmatchedAttributes[.font] as? UIFont == UIFont.govUK.bodySemibold)
        #expect(effectiveRangeUnmatched == NSRange(location: 0, length: 8))
    }

    @Test
    func process_multipleMatchesInWord_returnsCorrectAttributeString() {
        let result = processor.process(text: "cu", suggestion: "cucumber")

        #expect(result.string == "cucumber")

        var effectiveRangeMatched = NSRange(location: 0, length: 0)
        var effectiveRangeUnmatched = NSRange(location: 0, length: 0)
        let matchedAttributes = result.attributes(at: 0, effectiveRange: &effectiveRangeMatched)
        let unmatchedAttributes = result.attributes(at: 4, effectiveRange: &effectiveRangeUnmatched)
        #expect(matchedAttributes[.font] as? UIFont == UIFont.govUK.body)
        #expect(unmatchedAttributes[.font] as? UIFont == UIFont.govUK.bodySemibold)
        #expect(effectiveRangeMatched == NSRange(location: 0, length: 4))
        #expect(effectiveRangeUnmatched == NSRange(location: 4, length: 4))
    }

    @Test
    func process_multipleTextWordsMatchingSuggestion_returnsCorrectAttributeString() {
        let result = processor.process(text: "pay tax", suggestion: "tax to pay")

        #expect(result.string == "tax to pay")

        var firstEffectiveRangeMatched = NSRange(location: 0, length: 0)
        var secondEffectiveRangeMatched = NSRange(location: 0, length: 0)
        var effectiveRangeUnmatched = NSRange(location: 0, length: 0)
        let firstMatchedAttributes = result.attributes(at: 0, effectiveRange: &firstEffectiveRangeMatched)
        let secondMatchedAttributes = result.attributes(at: 7, effectiveRange: &secondEffectiveRangeMatched)
        let unmatchedAttributes = result.attributes(at: 4, effectiveRange: &effectiveRangeUnmatched)
        #expect(firstMatchedAttributes[.font] as? UIFont == UIFont.govUK.body)
        #expect(secondMatchedAttributes[.font] as? UIFont == UIFont.govUK.body)
        #expect(unmatchedAttributes[.font] as? UIFont == UIFont.govUK.bodySemibold)
        #expect(firstEffectiveRangeMatched == NSRange(location: 0, length: 3))
        #expect(secondEffectiveRangeMatched == NSRange(location: 7, length: 3))
        #expect(effectiveRangeUnmatched == NSRange(location: 4, length: 2))
    }

    @Test
    func process_emptyText_returnsCorrectAttributeString() {
        let result = processor.process(text: "", suggestion: "passport")

        #expect(result.string == "passport")

        var effectiveRange = NSRange(location: 0, length: 0)
        let attributes = result.attributes(at: 0, effectiveRange: &effectiveRange)
        #expect(attributes[.font] as? UIFont == UIFont.govUK.bodySemibold)
        #expect(effectiveRange == NSRange(location: 0, length: 8))
    }
}
