import Testing

@testable import govuk_ios

struct TopicDetailViewModelTests {

    let mockTopicsService = MockTopicsService()
    let mockAnalyticsService = MockAnalyticsService()
    let mockActivityService = MockActivityService()
    let mockURLOpener = MockURLOpener()
    
    @Test
    func init_noUnpopularContent_doesCreateSectionsCorrectly() async throws {
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
            subtopicAction: { _ in },
            stepByStepAction: { _ in }
        )

        try #require(sut.sections.count == 3)
        #expect(sut.sections[0].heading == "Popular pages in this topic")
        #expect(sut.sections[1].heading == "Step by step guides")
        #expect(sut.sections[2].heading == "Browse")
        
        #expect(sut.sections[0].rows.first is LinkRow)
        #expect(sut.sections[1].rows.last is LinkRow)
        #expect(sut.sections[2].rows.first is NavigationRow)
        #expect(sut.shouldShowDescription)
    }
    
    @Test
    func init_fiveStepByStep_doesCreateSectionsCorrectly() async throws {
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
            subtopicAction: { _ in },
            stepByStepAction: { _ in }
        )
        
        try #require(sut.sections.count == 3)
        #expect(sut.sections[0].heading == "Popular pages in this topic")
        #expect(sut.sections[1].heading == "Step by step guides")
        #expect(sut.sections[2].heading == "Browse")
        
        #expect(sut.sections[0].rows.first is LinkRow)
        
        #expect(sut.sections[1].rows.count == 4)
        #expect(sut.sections[1].rows.first is LinkRow)
        #expect(sut.sections[1].rows.last is NavigationRow)
        #expect(sut.sections[1].rows.last?.title == "See all")
        
        #expect(sut.sections[2].rows.first is NavigationRow)
    }
    
    @Test
    func init_hasUnpopularContent_doesCreateSectionsCorrectly() async throws {
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
            subtopicAction: { _ in },
            stepByStepAction: { _ in }
        )
        
        try #require(sut.sections.count == 4)
        #expect(sut.sections[0].heading == "Popular pages in this topic")
        #expect(sut.sections[1].heading == "Step by step guides")
        #expect(sut.sections[2].heading == "Services and information")
        #expect(sut.sections[3].heading == "Browse")
        
        #expect(sut.sections[0].rows.first is LinkRow)
        #expect(sut.sections[1].rows.first is LinkRow)
        #expect(sut.sections[2].rows.last is LinkRow)
        #expect(sut.sections[2].rows.count == 3)
        #expect(sut.sections[3].rows.first is NavigationRow)
    }

    @Test
    func init_subtopic_noOtherContent_returnsCorrectHeader() async throws {
        let expectedContent = TopicDetailResponse.arrange()
        mockTopicsService._stubbedFetchTopicDetailsResult = .success(expectedContent)
        let sut = TopicDetailViewModel(
            topic: TopicDetailResponse.Subtopic(ref: "test", title: "test", description: "description"),
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            subtopicAction: { _ in },
            stepByStepAction: { _ in }
        )

        #expect(sut.sections[3].heading == "Related")
        #expect(sut.sections[3].rows.count == expectedContent.subtopics.count)
    }

    @Test
    func tappingSubtopic_doesFireNavigationEvent() async throws {
        var didNavigate = false
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
            subtopicAction: { _ in
                didNavigate = true
            },
            stepByStepAction: { _ in }
        )
        
        try #require(sut.sections.count == 4)
        let subTopicRow = try #require(sut.sections[3].rows.first as? NavigationRow)
        subTopicRow.action()
        #expect(didNavigate)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Driving")
    }
    
    @Test
    func tappingContent_doesFireLinkEvent() async throws {
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
            subtopicAction: { _ in },
            stepByStepAction: { _ in }
        )
        
        try #require(sut.sections.count == 4)
        let contentRow = try #require(sut.sections[0].rows.first as? LinkRow)
        contentRow.action()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["url"] as? String == "https://www.gov.uk/view-driving-licence")
    }
    
    @Test
    func init_apiUnavailable_doesCreateCorrectErrorViewModel() async throws {
        mockTopicsService._stubbedFetchTopicDetailsResult = .failure(.apiUnavailable)
        let sut = TopicDetailViewModel(
            topic: MockDisplayableTopic(ref: "", title: ""),
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            subtopicAction: { _ in },
            stepByStepAction: { _ in }
        )
        let errorViewModel = try #require(sut.errorViewModel)
        #expect(errorViewModel.title == String.common.localized("genericErrorTitle"))
        #expect(errorViewModel.body == String.common.localized("genericErrorBody"))
        #expect(errorViewModel.buttonTitle == String.common.localized("genericErrorButtonTitle"))
        #expect(errorViewModel.buttonAccessibilityLabel
                == String.common.localized("genericErrorTitleAccessibilityLabel")
        )
        #expect(errorViewModel.isWebLink)
        errorViewModel.action?()
        #expect(mockURLOpener._receivedOpenIfPossibleUrlString == Constants.API.govukUrlString)
    }
    
    @Test
    func init_networkUnavailable_doesCreateCorrectErrorViewModel() async throws {
        mockTopicsService._stubbedFetchTopicDetailsResult = .failure(.networkUnavailable)
        let sut = TopicDetailViewModel(
            topic: MockDisplayableTopic(ref: "", title: ""),
            topicsService: mockTopicsService,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener,
            subtopicAction: { _ in },
            stepByStepAction: { _ in }
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
