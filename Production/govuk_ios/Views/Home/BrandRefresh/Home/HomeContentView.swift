import SwiftUI

struct HomeContentView: View {
    let viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            TopicsView(
                viewModel: viewModel.topicsWidgetViewModel
            )
        }
    }
}
