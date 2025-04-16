import SwiftUI
import UIKit
import Foundation
import UIComponents


struct LocalAuthorityWidgetView: View {
    @State private var showingSheet = false
    @StateObject private var viewModel: LocalAuthorityViewModel

    init(viewModel: LocalAuthorityViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.widgetViewTitleOne).font(Font.govUK.bodySemibold)
                Spacer()
            }
            Divider().overlay(Color(cgColor: UIColor.govUK.strokes.cardGreen.cgColor))
            HStack {
                Image("local_widget_icon", bundle: .main)
                VStack(alignment: .leading) {
                    Text(viewModel.widgetViewTitleTwo).font(Font.govUK.bodySemibold)
                    Text(viewModel.widgetViewDescription)
                        .font(Font.govUK.subheadline)
                        .foregroundColor(
                            Color(
                                UIColor.govUK.text.secondary
                            )
                        )
                }
                Spacer()
            }
        }
        .background {
            Color(uiColor: UIColor.govUK.fills.surfaceCardSelected)
                .ignoresSafeArea()
        }
        .onTapGesture {
            viewModel.trackWidgetTap()
            showingSheet.toggle()
        }.sheet(isPresented: $showingSheet) {
            LocalAuthorityExplainerView(viewModel: viewModel)
        }
    }
}
