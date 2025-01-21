import Foundation
import UIKit

class SuggestionHighlighterProcessor {
    func process(text: String, suggestion: String) -> NSAttributedString {
        let attributedSuggestion = NSMutableAttributedString()
        let userInputWords = splitIntoWords(text: text)
        let suggestionWords = splitIntoWords(text: suggestion)

        for (index, word) in suggestionWords.enumerated() {
            let highlightedAttributeString = highlightMatches(in: word, using: userInputWords)
            attributedSuggestion.append(highlightedAttributeString)

            if index < suggestionWords.count - 1 {
                attributedSuggestion.append(NSAttributedString(string: " "))
            }
        }

        return attributedSuggestion
    }

    private func splitIntoWords(text: String) -> [String] {
        return text.lowercased().split(separator: " ").map { String($0) }
    }

    private func highlightMatches(in suggestionWord: String,
                                  using userInputWords: [String]) -> NSAttributedString {
        let attributedText = NSMutableAttributedString()
        var lastIndex = suggestionWord.startIndex

        userInputWords.forEach { userInputWord in
            var searchRange = lastIndex..<suggestionWord.endIndex

            while let range = suggestionWord.range(
                of: userInputWord, options: [], range: searchRange
            ) {
                appendUnmatchedSubstring(
                    to: attributedText,
                    word: suggestionWord,
                    start: lastIndex,
                    end: range.lowerBound
                )
                appendMatchedSubstring(
                    to: attributedText,
                    word: suggestionWord,
                    range: range
                )

                lastIndex = range.upperBound
                searchRange = lastIndex..<suggestionWord.endIndex
            }
        }

        appendUnmatchedSubstring(
            to: attributedText, word: suggestionWord, start: lastIndex, end: suggestionWord.endIndex
        )

        return attributedText
    }

    private func appendUnmatchedSubstring(to attributedText: NSMutableAttributedString,
                                          word: String,
                                          start: String.Index,
                                          end: String.Index) {
        if start < end {
            let substring = word[start..<end]
            attributedText.append(NSAttributedString(string: String(substring), attributes: [
                NSAttributedString.Key.font: UIFont.govUK.bodySemibold
            ]))
        }
    }

    private func appendMatchedSubstring(to attributedText: NSMutableAttributedString,
                                        word: String,
                                        range: Range<String.Index>) {
        let matchedString = word[range]
        attributedText.append(NSAttributedString(string: String(matchedString), attributes: [
            NSAttributedString.Key.font: UIFont.govUK.body
        ]))
    }
}
