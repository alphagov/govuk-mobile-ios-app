import Foundation

struct SearchSuggestion: Identifiable, Hashable {
    var id = UUID()
    let text: String
}
