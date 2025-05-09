import Foundation
import Testing

@testable import govuk_ios

struct PersistentUserIdentifierManagerTests {
    @Test
    func process_notSeenOnboarding_setsIsReturningUserTrue() async {
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._savedItems = ["persistentUserIdentifier": UUID().uuidString]
        let sut = PersistentUserIdentifierManager(
            openSecureStoreService: mockSecureStoreService
        )
        let result = await sut.process(
            authenticationOnboardingFlowSeen: false, idToken: Self.idToken
        )

        await confirmation() { confirmation in
            if case let .success(isReturningUser) = result {
                #expect(isReturningUser)
                confirmation()
            }
        }
    }

    @Test
    func process_sameIdentifier_setsIsReturningUserTrue() async {
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._stubbedReadItemResult = await .success(
            userIdentifier(idToken: Self.idToken)
        )
        let sut = PersistentUserIdentifierManager(
            openSecureStoreService: mockSecureStoreService
        )
        let result = await sut.process(
            authenticationOnboardingFlowSeen: true, idToken: Self.idToken
        )

        await confirmation() { confirmation in
            if case let .success(isReturningUser) = result {
                #expect(isReturningUser)
                confirmation()
            }
        }
    }

    @Test
    func process_differentIdentifier_setsIsReturningUserFalse() async {
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._stubbedReadItemResult = .success(UUID().uuidString)
        let sut = PersistentUserIdentifierManager(
            openSecureStoreService: mockSecureStoreService
        )
        let result = await sut.process(
            authenticationOnboardingFlowSeen: true, idToken: Self.idToken
        )

        await confirmation() { confirmation in
            if case let .success(isReturningUser) = result {
                #expect(!isReturningUser)
                confirmation()
            }
        }
    }

    @Test
    func process_missingIdToken_returnsFailure() async {
        let mockSecureStoreService = MockSecureStoreService()
        let sut = PersistentUserIdentifierManager(
            openSecureStoreService: mockSecureStoreService
        )
        let result = await sut.process(
            authenticationOnboardingFlowSeen: true, idToken: nil
        )

        await confirmation() { confirmation in
            if case let .failure(error) = result {
                #expect(error == .missingPersistentUserIdentifierError)
                confirmation()
            }
        }
    }

    @Test
    func process_missingStoredIdentifier_returnsFailure() async {
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._stubbedReadItemResult = .failure(NSError())
        let sut = PersistentUserIdentifierManager(
            openSecureStoreService: mockSecureStoreService
        )
        let result = await sut.process(
            authenticationOnboardingFlowSeen: true, idToken: Self.idToken
        )

        await confirmation() { confirmation in
            if case let .failure(error) = result {
                #expect(error == .missingPersistentUserIdentifierError)
                confirmation()
            }
        }
    }

    @Test
    func process_failedIdentifierSave_returnsFailure() async {
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._stubbedSaveItemResult = .failure(NSError())
        mockSecureStoreService._stubbedReadItemResult = await .success(UUID().uuidString)
        let sut = PersistentUserIdentifierManager(
            openSecureStoreService: mockSecureStoreService
        )
        let result = await sut.process(
            authenticationOnboardingFlowSeen: true, idToken: Self.idToken
        )

        await confirmation() { confirmation in
            if case let .failure(error) = result {
                #expect(error == .savePersistentUserIdentifierError)
                confirmation()
            }
        }
    }
}

extension PersistentUserIdentifierManagerTests {
    func userIdentifier(idToken: String) async -> String {
        let payload = try? await JWTExtractor().extract(jwt: idToken)
        return payload!.sub
    }

    static var idToken = """
    eyJraWQiOiIxQ2RxbjVRXC9cL2Fqd3kzQ3ZYZGhScnVMTkFhMHpvNXRiNjFiSVhMdWhrUG89IiwiYWxnIjoiUlMyNTYifQ.eyJhdF9oYXNoIjoiZkNJS1NTT2JYcVFKS3g4cUFBSXZhQSIsInN1YiI6Ijg2NDI0MmM0LWQwZDEtNzA1OC04OTgzLThiMzFhMjI4ZTM4MCIsImNvZ25pdG86Z3JvdXBzIjpbImV1LXdlc3QtMl9mSUo2RjI1Wmhfb25lbG9naW4iXSwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAuZXUtd2VzdC0yLmFtYXpvbmF3cy5jb21cL2V1LXdlc3QtMl9mSUo2RjI1WmgiLCJjb2duaXRvOnVzZXJuYW1lIjoib25lbG9naW5fdXJuOmZkYzpnb3YudWs6MjAyMjpmZnNjc3lzcDJvaWZnaGNsYWtpdy0ybXVubHR5cnBhYWJmOXdtYW50bDlrIiwibm9uY2UiOiIyWlVCaEliUGpucVRqd3ZGU2VDT3lJc2tPRDRCazREVXcyM3RUekVDWElnIiwib3JpZ2luX2p0aSI6IjcwMTA5YzIyLWZkMjUtNGY1Ny1iNjU2LWY3NjE2NjQ5NGIyNyIsImF1ZCI6IjEyMWY1MWoxczRrbWs5aTk4dW0wYjVtcGhoIiwiaWRlbnRpdGllcyI6W3siZGF0ZUNyZWF0ZWQiOiIxNzQyODI0MjgxMTkwIiwidXNlcklkIjoidXJuOmZkYzpnb3YudWs6MjAyMjpmRlNDU1lTUDJvSUZnaGNMYWtJVy0ybVVObHRZUlBhQWJmOVdNQW50TDlrIiwicHJvdmlkZXJOYW1lIjoib25lbG9naW4iLCJwcm92aWRlclR5cGUiOiJPSURDIiwiaXNzdWVyIjpudWxsLCJwcmltYXJ5IjoidHJ1ZSJ9XSwidG9rZW5fdXNlIjoiaWQiLCJhdXRoX3RpbWUiOjE3NDU1NzYzMjEsImV4cCI6MTc0NTY2MjcyMSwiaWF0IjoxNzQ1NTc2MzIxLCJqdGkiOiIyMjM2YWRkNC0zZWM5LTQ0OWEtYTI0YS00MWRlZDcwOGQ3ZTEiLCJlbWFpbCI6Impvc2guZHViZXkxQGRpZ2l0YWwuY2FiaW5ldC1vZmZpY2UuZ292LnVrIn0.AchyWXMGUaNZz9NlYAKbzkH9LIiZmucLvQF8j3aLDlf6mQVM17i0ar4MKCsAt4sTeQQoyOCHUOXDT9TjCr2jOFKFG1Yn2uAMj-LNEehMmN4721qTVKiNrwD7zfr1bTB-Awwi15KSl3683vEA4s-gJMAttwLMB_IWJ7w3-fdg-fBehAJNaaJiWexpe4sjmmn5A5s7elxzKQcjXuyKWT28NbkxAJtm2FUX0Z2jI4szc0cBodbK-26Ic_136mTMmAolzRkl7SP83bzRfEKh5Lv_6ZMY-3YhPCJD2kTdqT4VTL5UGQ18QzRWjL2DEtV0_Vd4RJpZrr1xSMG6c9yA2XTBWQ
    """
}
