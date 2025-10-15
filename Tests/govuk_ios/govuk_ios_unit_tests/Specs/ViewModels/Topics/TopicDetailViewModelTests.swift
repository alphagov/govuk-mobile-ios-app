import Testing
import UIKit

@testable import govuk_ios
@testable import GOVKit

struct TopicDetailViewModelTests {

    let mockTopicsService = MockTopicsService()
    let mockAnalyticsService = MockAnalyticsService()
    let mockActivityService = MockActivityService()
    let mockURLOpener = MockURLOpener()
    
    @Test
    func init_noUnpopularContent_doesCreateSectionsCorrectly() throws {
        mockTopicsService._stubbedFetchTopicDetailsResult = .success(
            .arrange(
                fileName: "NoUnpopularContent"
            )
        )
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = TopicDetailViewModel(
            topic: Topic.arrange(context: coreData.viewContext),
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            actions: .empty
        )

        try #require(sut.sections.count == 3)
        #expect(sut.sections[0].heading?.title == "Popular pages in this topic")
        #expect(sut.sections[0].heading?.icon == UIImage.topicPopularPagesIcon)

        #expect(sut.sections[1].heading?.title == "Step by step guides")
        #expect(sut.sections[1].heading?.icon == UIImage.topicStepByStepIcon)

        #expect(sut.sections[2].heading?.title == "Browse")
        #expect(sut.sections[2].heading?.icon == UIImage.topicBrowseIcon)

        #expect(sut.sections[0].rows.first is LinkRow)
        #expect(sut.sections[1].rows.last is LinkRow)
        #expect(sut.sections[2].rows.first is NavigationRow)
        #expect(sut.shouldShowDescription)
    }
    
    @Test
    func init_fiveStepByStep_doesCreateSectionsCorrectly() throws {
        mockTopicsService._stubbedFetchTopicDetailsResult = .success(
            .arrange(
                fileName: "FiveStepByStep"
            )
        )
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = TopicDetailViewModel(
            topic: Topic.arrange(context: coreData.viewContext),
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            actions: .empty
        )
        
        try #require(sut.sections.count == 3)
        #expect(sut.sections[0].heading?.title == "Popular pages in this topic")
        #expect(sut.sections[0].heading?.icon == UIImage.topicPopularPagesIcon)

        #expect(sut.sections[1].heading?.title == "Step by step guides")
        #expect(sut.sections[1].heading?.icon == UIImage.topicStepByStepIcon)

        #expect(sut.sections[2].heading?.title == "Browse")
        #expect(sut.sections[2].heading?.icon == UIImage.topicBrowseIcon)

        #expect(sut.sections[0].rows.first is LinkRow)
        
        #expect(sut.sections[1].rows.count == 4)
        #expect(sut.sections[1].rows.first is LinkRow)
        #expect(sut.sections[1].rows.last is NavigationRow)
        #expect(sut.sections[1].rows.last?.title == "See all")
        
        #expect(sut.sections[2].rows.first is NavigationRow)
    }
    
    @Test
    func init_hasUnpopularContent_doesCreateSectionsCorrectly() throws {
        mockTopicsService._stubbedFetchTopicDetailsResult = .success(
            .arrange(
                fileName: "UnpopularContent"
            )
        )
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = TopicDetailViewModel(
            topic: Topic.arrange(context: coreData.viewContext),
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            actions: .empty
        )
        
        try #require(sut.sections.count == 4)
        #expect(sut.sections[0].heading?.title == "Popular pages in this topic")
        #expect(sut.sections[0].heading?.icon == UIImage.topicPopularPagesIcon)

        #expect(sut.sections[1].heading?.title == "Step by step guides")
        #expect(sut.sections[1].heading?.icon == UIImage.topicStepByStepIcon)

        #expect(sut.sections[2].heading?.title == "Services and information")
        #expect(sut.sections[2].heading?.icon == UIImage.topicServicesIcon)

        #expect(sut.sections[3].heading?.title == "Browse")
        #expect(sut.sections[3].heading?.icon == UIImage.topicBrowseIcon)

        #expect(sut.sections[0].rows.first is LinkRow)
        #expect(sut.sections[1].rows.first is LinkRow)
        #expect(sut.sections[2].rows.last is LinkRow)
        #expect(sut.sections[2].rows.count == 3)
        #expect(sut.sections[3].rows.first is NavigationRow)
    }

    @Test
    func init_subtopic_noOtherContent_returnsCorrectHeader() throws {
        let expectedContent = TopicDetailResponse.arrange()
        mockTopicsService._stubbedFetchTopicDetailsResult = .success(expectedContent)
        let sut = TopicDetailViewModel(
            topic: TopicDetailResponse.Subtopic(ref: "test", title: "test", description: "description"),
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            actions: .empty
        )

        #expect(sut.sections[3].heading?.title == "Related")
        #expect(sut.sections[3].heading?.icon == UIImage.topicRelatedIcon)
        #expect(sut.sections[3].rows.count == expectedContent.subtopics.count)
    }

    @Test
    func tappingSubtopic_doesFireNavigationEvent() throws {
        var didNavigate = false
        mockTopicsService._stubbedFetchTopicDetailsResult = .success(
            .arrange(
                fileName: "UnpopularContent"
            )
        )
        let actions = TopicDetailViewModel.Actions(
            subtopicAction: { _ in
                didNavigate = true
            },
            stepByStepAction: { _ in },
            openAction: { _ in }
        )
        let sut = TopicDetailViewModel(
            topic: MockDisplayableTopic(ref: "", title: ""),
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            actions: actions
        )
        
        try #require(sut.sections.count == 4)
        let subTopicRow = try #require(sut.sections[3].rows.first as? NavigationRow)
        subTopicRow.action()
        #expect(didNavigate)
        #expect(mockAnalyticsService._trackedEvents.count == 2)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Driving")
    }
    
    @Test
    func tappingContent_doesFireLinkEvent() throws {
        mockTopicsService._stubbedFetchTopicDetailsResult = .success(
            .arrange(
                fileName: "UnpopularContent"
            )
        )
        let sut = TopicDetailViewModel(
            topic: MockDisplayableTopic(ref: "", title: ""),
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            actions: .empty
        )
        
        try #require(sut.sections.count == 4)
        let contentRow = try #require(sut.sections[0].rows.first as? LinkRow)
        contentRow.action()
        #expect(mockAnalyticsService._trackedEvents.count == 2)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["url"] as? String == "https://www.gov.uk/view-driving-licence")
    }

    @Test
    func init_apiUnavailable_doesCreateCorrectErrorViewModel() throws {
        mockTopicsService._stubbedFetchTopicDetailsResult = .failure(.apiUnavailable)
        let sut = TopicDetailViewModel(
            topic: MockDisplayableTopic(ref: "", title: ""),
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            actions: .empty
        )
        let errorViewModel = try #require(sut.errorViewModel)
        #expect(errorViewModel.title == String.common.localized("genericErrorTitle"))
        #expect(errorViewModel.body == String.common.localized("genericErrorBody"))
        #expect(errorViewModel.buttonTitle == String.common.localized("genericErrorButtonTitle"))
        #expect(errorViewModel.buttonAccessibilityLabel
                == String.common.localized("genericErrorButtonTitleAccessibilityLabel")
        )
        #expect(errorViewModel.isWebLink)
        errorViewModel.action?()
        #expect(mockURLOpener._receivedOpenIfPossibleUrl == Constants.API.govukBaseUrl)
    }
    
    @Test
    func init_networkUnavailable_doesCreateCorrectErrorViewModel() throws {
        mockTopicsService._stubbedFetchTopicDetailsResult = .failure(.networkUnavailable)
        let sut = TopicDetailViewModel(
            topic: MockDisplayableTopic(ref: "", title: ""),
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            actions: .empty
        )
        let errorViewModel = try #require(sut.errorViewModel)
        #expect(errorViewModel.title == String.common.localized("networkUnavailableErrorTitle"))
        #expect(errorViewModel.body == String.common.localized("networkUnavailableErrorBody"))
        #expect(errorViewModel.buttonTitle == String.common.localized("networkUnavailableButtonTitle"))
        #expect(errorViewModel.buttonAccessibilityLabel == nil)
        #expect(errorViewModel.isWebLink == false)
        mockTopicsService._fetchDetailsCalled = false
        errorViewModel.action?()
        #expect(mockTopicsService._fetchDetailsCalled)
    }
}

extension TopicDetailViewModel.Actions {
    static var empty: TopicDetailViewModel.Actions {
        .init(
            subtopicAction: { _ in },
            stepByStepAction: { _ in },
            openAction: { _ in }
        )
    }
}
