import Foundation

struct CarouselCardGroup {
    var title: String
    var cards: [CarouselCard]
}

struct CarouselCard: Identifiable {
    var id = UUID()
    var title: String
    var action: () -> Void
}
