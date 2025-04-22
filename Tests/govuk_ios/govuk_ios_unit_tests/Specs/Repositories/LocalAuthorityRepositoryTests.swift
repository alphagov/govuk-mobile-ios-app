import Foundation
import Testing
import CoreData

@testable import govuk_ios

@Suite
@MainActor
struct LocalAuthorityRepositoryTests {

    @Test func save_localAuthorityItem_savesObject() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = LocalAuthorityRepository(coreData: coreData)

        let parentAuthority = Authority(
            name: "Derbyshire County Council",
            homepageUrl: "https://www.derbyshiredales.gov.uk/",
            tier: "county",
            slug: "derbyshire"
        )
        let localAuthority = LocalAuthority(
            localAuthority: Authority(
                name: "Derbyshire Dales District Council",
                homepageUrl: "https://www.derbyshiredales.gov.uk/",
                tier: "district",
                slug: "derbyshire-dales",
                parent: parentAuthority
            )
        )

        sut.save(localAuthority)

        let localAuthorityItems = sut.fetchLocalAuthority()
        #expect(localAuthorityItems.count == 2)
        let childAuthority = localAuthorityItems.first(where: { $0.parent != nil })
        #expect(childAuthority?.name == "Derbyshire Dales District Council")
        #expect(childAuthority?.homepageUrl == "https://www.derbyshiredales.gov.uk/")
        #expect(childAuthority?.tier == "district")
        #expect(childAuthority?.slug == "derbyshire-dales")
        let parent = childAuthority?.parent
        #expect(parent?.name == "Derbyshire County Council")
        #expect(parent?.homepageUrl == "https://www.derbyshiredales.gov.uk/")
        #expect(parent?.tier == "county")
        #expect(parent?.slug == "derbyshire")
        #expect(parent?.parent == nil)

    }

    @Test func save_localAuthorityItem_replacesOldItems() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = LocalAuthorityRepository(coreData: coreData)

        let parentAuthority = Authority(
            name: "Derbyshire County Council",
            homepageUrl: "https://www.derbyshiredales.gov.uk/",
            tier: "county",
            slug: "derbyshire-dales"
        )
        let localAuthority = LocalAuthority(
            localAuthority: Authority(
                name: "Derbyshire Dales District Council",
                homepageUrl: "https://www.derbyshiredales.gov.uk/",
                tier: "district",
                slug: "derbyshire-dales",
                parent: parentAuthority
            )
        )

        sut.save(localAuthority)

        let newLocalAuthority = LocalAuthority(
            localAuthority: Authority(
                name: "London Borough of Tower Hamlets",
                homepageUrl: "https://www.towerhamlets.gov.uk",
                tier: "unitary",
                slug: "tower-hamlets"
            )
        )

        sut.save(newLocalAuthority)

        let localAuthorityItems = sut.fetchLocalAuthority()
        #expect(localAuthorityItems.count == 1)
        #expect(localAuthorityItems.first?.name == "London Borough of Tower Hamlets")
        #expect(localAuthorityItems.first?.homepageUrl == "https://www.towerhamlets.gov.uk")
        #expect(localAuthorityItems.first?.tier == "unitary")
        #expect(localAuthorityItems.first?.slug == "tower-hamlets")
        #expect(localAuthorityItems.first?.parent == nil)
    }

}
