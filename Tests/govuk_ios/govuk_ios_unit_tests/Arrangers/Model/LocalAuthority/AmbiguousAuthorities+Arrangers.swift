import Foundation

@testable import govuk_ios

extension AmbiguousAuthorities {
    static func arrange() -> AmbiguousAuthorities {
        let authorityOne = Authority(
            name: "Bournemouth, Christchurch and Poole Council",
            homepageUrl: "homepageURL1",
            tier: "tier1",
            slug: "slug1"
        )
        let authorityTwo = Authority(
            name: "Dorset Council",
            homepageUrl: "homepageUR2",
            tier: "tier2",
            slug: "slug2"
        )
        let addressOne = LocalAuthorityAddress(
            address: "address1",
            slug: "slug1",
            name: "Bournemouth, Christchurch and Poole Council"
        )
        let addressTwo = LocalAuthorityAddress(
            address: "address2",
            slug: "slug2",
            name: "Dorset Council"
        )
        let ambigiousAuthorities = AmbiguousAuthorities(
            authorities: [authorityOne, authorityTwo],
            addresses: [addressOne, addressTwo]
        )
        return ambigiousAuthorities
    }
}
