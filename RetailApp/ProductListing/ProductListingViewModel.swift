import Foundation
import UIKit

class ProductListingViewModel{
    
    var productList : Observable<[ProductViewModel]> = Observable<[ProductViewModel]>([ProductViewModel]())
    let baseURL = "http://admin:password@interview-tech-testing.herokuapp.com"
    private var productListingService: ProductListingServiceImplementation? = nil
    var productImage : Observable<[UIImage]>? = Observable<[UIImage]>([])
    private var offerViewModel = OfferViewModel(offers: Offers(id: "", title: "", type: ""))

    init(){
        // Fetch all products
        getAllProducts()
        
        // Fetch all user offers
        offerViewModel.getUserOffers()
    }
    
    func getAllProducts(){

        let sessionAPI = API(urlSession: URLSession(configuration: .default), baseURL: URL(string: baseURL)!)
        productListingService = ProductListingServiceImplementation(api:sessionAPI)

        productListingService?.getAllProducts { result in
            do {
                self.productList.value = try result.unwrapped().products.map(ProductViewModel.init)
                
            } catch {
              print(error.localizedDescription)
            }
        }
    }
    
    func downloadProductImage(imageKey: String) {
        let imageService = ImageServiceImplementation(api: API(urlSession: URLSession(configuration: .default), baseURL: URL(string: baseURL)!))
        
        imageService.downloadImage(key: imageKey) { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            if let image = try? result.unwrapped() {
                strongSelf.productImage?.value.append(image)
                
            }
        }
    }
}

class ProductViewModel{
    
    var product: Product
    
    init(product: Product){
        self.product = product
    }
    
    var productId: String{
        return self.product.id
    }
    
    var productName: String{
        return self.product.name
    }
    
    var imageKey: String{
        return self.product.imageKey
    }
    
    var price: Price{
        return self.product.price
    }
    
    var offerIds: [String]{
        return self.product.offerIds
    }
}

