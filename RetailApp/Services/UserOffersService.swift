import Foundation

protocol UserOffersService {
  func getUserOffers(completion: @escaping (Result<UserOffers, Error>) -> Void)
}

class UserOffersServiceImplementation: UserOffersService {
  private let api: API

  init(api: API) {
    self.api = api
  }

  func getUserOffers(completion: @escaping (Result<UserOffers, Error>) -> Void) {
    let resource = Resource<UserOffers>(path: "/api/user/2/offers")
    api.load(resource, completion: completion)
  }
}
