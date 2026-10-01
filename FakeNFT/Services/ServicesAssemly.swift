final class ServicesAssembly {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    var nftService: NftService {
        NftServiceImpl(networkClient: networkClient)
    }
    
    var collectionService: CollectionService {
        CollectionServiceImpl(networkClient: networkClient)
    }
    
    var profileService: ProfileService {
        ProfileServiceImpl(networkClient: networkClient)
    }
    
    var cartService: CartServiceProtocol {
        CartService(
            networkClient: networkClient,
            nftService: nftService
        )
    }
    
    var cartSortService: CartSortOptionServiceProtocol {
        CartSortOptionService()
    }
    
    var currencyService: CurrencyServiceProtocol {
        CurrencyService(networkClient: networkClient)
    }
}
