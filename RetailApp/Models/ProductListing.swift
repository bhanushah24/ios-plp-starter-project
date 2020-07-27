import Foundation

struct ProductListing: Codable{
    let products: [Product]
}

struct Product: Codable{
    let id: String
    let name: String
    let imageKey: String
    let price: Price
    let offerIds : [String]
}
