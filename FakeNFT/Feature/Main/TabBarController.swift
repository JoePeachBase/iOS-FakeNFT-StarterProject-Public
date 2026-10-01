import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.fill"),
        tag: 0
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(resource: .cartInactive),
        selectedImage: UIImage(resource: .cartActive)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .systemBackground
        
        let catalogViewController = getCatalogViewController()
        let cartViewController = getCartViewController()
        
        viewControllers = [catalogViewController, cartViewController]
    }
    
    private func getCatalogViewController() -> UIViewController {
        let catalogViewModel = CatalogViewModel(collectionService: servicesAssembly.collectionService)
        let collectionDetailAssembly = CollectionDetailAssembly(serviceAssembly: servicesAssembly)
        let catalogViewController = CatalogViewController(
            viewModel: catalogViewModel,
            collectionDetailAssembly: collectionDetailAssembly
        )
        catalogViewController.tabBarItem = catalogTabBarItem
        
        return UINavigationController(rootViewController: catalogViewController)
    }
    
    private func getCartViewController() -> UIViewController {
        let paymentAssembly = PaymentAssembly(servicesAssembler: servicesAssembly)
        let cartAssembly = CartAssembly(servicesAssembler: servicesAssembly, paymentAssembly: paymentAssembly)
        let cartViewController = cartAssembly.build()
        cartViewController.tabBarItem = cartTabBarItem
        
        return UINavigationController(rootViewController: cartViewController)
    }
}
