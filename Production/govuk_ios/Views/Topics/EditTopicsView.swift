import SwiftUI

struct EditTopicsView: View {
    @StateObject var viewModel: EditTopicsViewModel

    var body: some View {
        VStack {
            Text("Topics you select will be shown on ")
                .multilineTextAlignment(.leading)
            ScrollView {
                GroupedList(content: viewModel.sections)
            }
        }
        .navigationTitle("Edit your topics")
        .toolbar {
            HStack {
                Spacer()
                Button("Done") {
                    viewModel.updateFovoriteTopics()
                }
            }
        }
    }
}
