import SwiftUI

struct ChatEllipsesView: View {
    @State private var dots = ""
    private let baseText: String

    private var ellipsesTimer = Timer.publish(every: 1.0,
                                              on: .main,
                                              in: .common)
        .autoconnect()

    init(_ baseText: String) {
        self.baseText = baseText
    }

    var body: some View {
        Text(baseText + dots)
            .animation(.easeIn(duration: 0.25), value: dots)
        .onReceive(ellipsesTimer, perform: { _ in
            if dots.count < 3 {
                dots.append(".")
            } else {
                dots = ""
            }
        })
    }
}

#Preview {
    HStack {
        ChatEllipsesView("Generating your answer")
        Spacer()
    }
}
