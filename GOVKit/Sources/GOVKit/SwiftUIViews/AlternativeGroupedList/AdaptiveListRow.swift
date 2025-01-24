import SwiftUI

struct AdaptiveListRow: View,
                        Identifiable {
    let view: AnyView
    let id = UUID().uuidString

    init(view: any View) {
        self.view = AnyView(view)
    }

    var body: AnyView {
        view
    }
}

