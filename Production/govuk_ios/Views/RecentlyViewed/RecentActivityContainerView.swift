// import SwiftUI
// import UIComponents
//
// struct RecentActivityContainerView: View {
//    @ObservedObject private var viewModel: RecentActivitiesContainerViewModel
//
//    init(viewModel: RecentActivitiesContainerViewModel) {
//        self.viewModel = viewModel
//    }
//
//    var body: some View {
//        VStack {
//            RecentActivityView(
//                viewModel: RecentActivitiesViewModel(
//                    urlOpener: UIApplication.shared,
//                    analyticsService: viewModel.analyticsService
//                )
//            )
//            // }.navigationTitle(viewModel.navigationTitle)
//            //            .onAppear {
//            //                viewModel.trackScreen(screen: self)
//            //            }
//        }
//    }
// }
