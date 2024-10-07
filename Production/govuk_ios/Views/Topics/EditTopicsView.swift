import SwiftUI

struct EditTopicsView: View {
    @StateObject var viewModel: EditTopicsViewModel

    var body: some View {
        Text("Edit Topics")
            .navigationTitle("Edit your topics")
            .toolbar {
                HStack {
                    Spacer()
                    Button("Done") {
                        viewModel.dismissAction()
                    }
                }
            }
    }
}

#Preview {
    EditTopicsView(viewModel: EditTopicsViewModel(topics: [],
                                                  dismissAction: { }))
}
