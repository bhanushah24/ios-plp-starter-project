import Foundation

struct UserOffers: Codable{
    let availableBadges: String
    let offers: [Offers]
}

struct Offers: Codable{
    let id: String
    let title: String
    let type: String
}
