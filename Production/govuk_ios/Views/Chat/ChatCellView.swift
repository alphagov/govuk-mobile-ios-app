import SwiftUI
import GOVKit
import UIComponents
import MarkdownUI

struct ChatCellView: View {
    @StateObject private var viewModel: ChatCellViewModel

    init(viewModel: ChatCellViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading) {
            switch viewModel.type {
            case .question:
                questionView
            case .pendingAnswer:
                pendingAnswerView
            case .answer:
                answerView
            case .intro:
                introView
            case .loading:
                questionView
            }
        }
        .background(viewModel.backgroundColor)
        .opacity(viewModel.isVisible ? 1 : 0)
        .scaleEffect(viewModel.isVisible ? 1 : scale, anchor: anchor)
        .animation(.easeIn(duration: duration).delay(delay),
                   value: viewModel.isVisible)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var anchor: UnitPoint {
        switch viewModel.type {
        case .intro:
                .center
        case .question, .loading:
                .bottomTrailing
        case .pendingAnswer, .answer:
                .bottomLeading
        }
    }

    private var scale: CGFloat {
        if viewModel.type == .pendingAnswer {
            1.0
        } else {
            0.90
        }
    }

    private var duration: CGFloat {
        if viewModel.type == .intro {
            0.5
        } else {
            0.25
        }
    }

    private var delay: CGFloat {
        if viewModel.type == .loading {
            0.4
        } else {
            0.0
        }
    }

    private var questionView: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(viewModel.message)
                .font(Font.govUK.body)
                .multilineTextAlignment(.leading)
                .padding()
        }
    }

    private var pendingAnswerView: some View {
        HStack(spacing: 5) {
            AnimatedAPNGImageView(imageName: "generating-your-answer")
                .frame(width: 24, height: 24)
            ChatEllipsesView(viewModel.message)
                .font(Font.govUK.body)
            Spacer()
        }
    }

    private var introView: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = viewModel.title {
                Text(title)
                    .font(Font.govUK.bodySemibold)
            }
            Text(viewModel.message)
                .font(Font.govUK.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }

    private var answerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = viewModel.title {
                Text(title)
                    .font(Font.govUK.bodySemibold)
            }
            HStack(alignment: .firstTextBaseline) {
                markdownView
            }
            Divider()
                .overlay(Color(UIColor.govUK.strokes.chatDivider))
                .padding(.vertical, 8)
            warningView
            if !viewModel.sources.isEmpty {
                sourceView
            }
        }
        .padding()
    }

    private var sourceView: some View {
        VStack(alignment: .leading, spacing: 8) {
            DisclosureGroup {
                sourceListView
            } label: {
                Text(String.chat.localized("sourceListTitle"))
                    .foregroundColor(Color(UIColor.govUK.text.primary))
            }
        }
        .disclosureGroupStyle(
            ChatDisclosure(trackToggle: { isExpanded in
                viewModel.trackSourceListToggle(isExpanded: isExpanded)
            })
        ).padding(.top, 8)
    }

    private var warningView: some View {
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(Font.govUK.bodySemibold)
                .foregroundColor(Color(.govUK.text.trailingIcon))
                .accessibilityHidden(true)
            Text(String.chat.localized("mistakesTitle"))
                .font(Font.govUK.bodySemibold)
        }
    }

    private var markdownView: some View {
        Markdown(viewModel.message)
            .markdownTextStyle(\.link,
                                textStyle: {
                ForegroundColor(Color(UIColor.govUK.text.link))
            })
            .fixedSize(horizontal: false, vertical: true)
            .environment(\.openURL, OpenURLAction { url in
                viewModel.openURL(url: url, type: .responseLink)
                return .handled
            })
    }

    private var sourceListView: some View {
        ForEach(viewModel.sources, id: \.url) { source in
            Link(destination: source.urlWithFallback) {
                sourceListItemTitleView(title: source.title)
            }
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityHint(String.common.localized("openWebLinkHint"))
            .accessibilityRemoveTraits(.isButton)
            .environment(\.openURL, OpenURLAction { url in
                viewModel.openURL(url: url, type: .sourceLink)
                return .handled
            })
            Divider()
                .overlay(Color(UIColor.govUK.strokes.chatDivider))
                .opacity(source.url == viewModel.sources.last?.url ? 0 : 1)
        }
    }

    private func sourceListItemTitleView(title: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(Color(UIColor.govUK.text.link))
                .multilineTextAlignment(.leading)
                .padding(.top, 4)
            Spacer()
        }
    }
}

struct ChatDisclosure: DisclosureGroupStyle {
    var trackToggle: (Bool) -> Void

    func makeBody(configuration: Configuration) -> some View {
        VStack {
            disclosureButtonView(configuration: configuration)
            if configuration.isExpanded {
                configuration.content
            }
        }
    }

    private func disclosureButtonView(configuration: Configuration) -> some View {
        Button {
            withAnimation {
                configuration.isExpanded.toggle()
                trackToggle(configuration.isExpanded)
            }
        } label: {
            HStack(alignment: .firstTextBaseline) {
                configuration.label
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: configuration.isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(Color(UIColor.govUK.text.link))
            }
        }
    }
}

#Preview {
    // swiftlint:disable:next line_length
    let previewMessage: String = "You can apply for a UK passport either online or using a paper form.\n\n### Apply Online\n\n* You will need a [digital photo][1] of yourself, someone to confirm\n  your identity, [supporting documents][2], and a credit or debit card.\n* The cost is £94.50.\n* After submitting your application, you will need to ask someone to\n  confirm your identity. They will receive an email from HM Passport\n  Office with instructions and can confirm your identity online.\n* For more details, you can [start your application online][3].\n\n### Apply with a Paper Form\n\n* You can get a paper application form from a Post Office that offers\n  the [Passport Check and Send service][4] or from the [Passport\n  Adviceline][5].\n* Fill in sections 1, 2, 3, 4, 5, and 9 of the form. Your\n  countersignatory will need to fill in section 10.\n* You will need to send your filled-in application form, [supporting\n  documents][2], and two passport photos (one signed and dated by your\n  countersignatory).\n* The cost is £107, and it takes longer to apply by post than online.\n* You can post your application using the pre-printed envelope that\n  comes with the form or take it to the Post Office if you want to use\n  the [Passport Check and Send service][4].\n\nFor more detailed information on applying for a passport, visit the\n[GOV.UK page on getting your first adult passport][6].\n\n\n\n[1]: https://www.integration.publishing.service.gov.uk/photos-for-passports/rules-for-digital-photos\n[2]: https://www.integration.publishing.service.gov.uk/apply-first-adult-passport/what-documents-you-need-to-apply\n[3]: https://www.passport.service.gov.uk/filter?_ga=2.80103903.932495294.1537777477-946183992.1475581620\n[4]: https://www.integration.publishing.service.gov.uk/how-the-post-office-check-and-send-service-works\n[5]: https://www.integration.publishing.service.gov.uk/passport-advice-line\n[6]: https://www.integration.publishing.service.gov.uk/apply-first-adult-passport/apply-by-post#fill-in-your-application-form"

    ScrollView {
        VStack {
            ChatCellView(
                viewModel: ChatCellViewModel(
                    message: "What is your quest what is your",
                    id: UUID().uuidString,
                    type: .question)
            )
            ChatCellView(
                viewModel: ChatCellViewModel(
                    message: previewMessage,
                    id: UUID().uuidString,
                    type: .answer,
                    sources: [
                        Source(title: "Source 1", url: "https://www.example.com"),
                        Source(title: "Source 2", url: "https://www.other.com")
                    ])
            )
            ChatCellView(viewModel: .gettingAnswer)
        }
        .padding()
    }
}
