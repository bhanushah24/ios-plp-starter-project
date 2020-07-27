import Foundation
import UIKit

class OfferViewModel{
    
    var offers: Offers
    
    init(offers: Offers){
        self.offers = offers
    }
    
    var offerId: String{
        return self.offers.id
    }
    
    var offerTitle: String{
        return self.offers.title
    }
    
    var offerType: String{
        return self.offers.type
    }
    
    var offerList : Observable<[OfferViewModel]> = Observable<[OfferViewModel]>([OfferViewModel]())
    let baseURL = "http://admin:password@interview-tech-testing.herokuapp.com"
    private var userOffersService: UserOffersServiceImplementation? = nil
    var availableBadges: String = ""
    
    
    func getUserOffers(){
        
        let sessionAPI = API(urlSession: URLSession(configuration: .default), baseURL: URL(string: baseURL)!)
        userOffersService = UserOffersServiceImplementation(api:sessionAPI)
        
        userOffersService?.getUserOffers { result in
            do {
                let offerResults = try result.unwrapped()
                self.availableBadges = offerResults.availableBadges
                self.offerList.value = offerResults.offers.map(OfferViewModel.init)
                self.formatUserOffer()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func formatUserOffer(){
        let offerPriorityOrder = self.availableBadges.components(separatedBy: "||").sorted()
        for offer in offerPriorityOrder{
            _ = offer.components(separatedBy: ":")
        }
    }
}
