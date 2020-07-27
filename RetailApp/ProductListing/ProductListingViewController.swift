import UIKit

class ProductListingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let viewModel: ProductListingViewModel
    private var productListingViewModel = ProductListingViewModel()
    private var priceFormatter: PriceFormatter? = PriceFormatterImplementation()
    let reuseIdentifier = "ProductListingCell"
    let baseURL = "http://admin:password@interview-tech-testing.herokuapp.com"

    
    private let imageService: ImageService? = nil
    
    init(viewModel: ProductListingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tops"
        self.collectionView.register(UINib(nibName: "ProductListingCell", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier)
        bind()
    }
    
    private func bind() {
        viewModel.productList.bind(self) { [weak self] viewModel in
            let seconds = 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.productList.value.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ProductListingCell
        
        if (self.viewModel.productImage?.value.count)! > indexPath.row {
            cell.productImage.image = self.viewModel.productImage?.value[indexPath.row]
        }
        cell.productName.text =  self.viewModel.productList.value[indexPath.row].productName
        cell.priceLabel.attributedText = priceFormatter?.formatPrice(self.viewModel.productList.value[indexPath.row].price)

        self.viewModel.downloadProductImage(imageKey: self.viewModel.productList.value[indexPath.row].imageKey)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat((collectionView.frame.size.width / 2) - 10), height: CGFloat(350))
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let productDetailViewModel = ProductDetailsViewModel(productRequest: ProductRequestClass(id: viewModel.productList.value[indexPath.row].productId, price: viewModel.productList.value[indexPath.row].price, name: viewModel.productList.value[indexPath.row].productName), listingImage: viewModel.productImage?.value[indexPath.row], productDetailsService: ProductDetailsServiceImplementation(api: API(urlSession: URLSession(configuration: .default), baseURL: URL(string: baseURL)!)), imageService: ImageServiceImplementation(api: API(urlSession: URLSession(configuration: .default), baseURL: URL(string: baseURL)!)))

       let prodectdetailViewController =  ProductDetailsViewController(viewModel: productDetailViewModel)

        self.navigationController?.pushViewController(prodectdetailViewController, animated: true)

    }
}
