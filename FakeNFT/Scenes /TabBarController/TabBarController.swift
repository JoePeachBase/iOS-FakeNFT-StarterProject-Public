import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(resource: .cartInactive),
        selectedImage: UIImage(resource: .cartActive)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogViewController = getCatalogViewController()
        let cartViewController = getCartViewController()
        
        viewControllers = [catalogViewController, cartViewController]
        
        view.backgroundColor = .systemBackground
    }
    
    private func getCatalogViewController() -> UIViewController {
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        return catalogController
    }
    
    private func getCartViewController() -> UIViewController {
        let paymentAssembly = PaymentAssembly(servicesAssembler: servicesAssembly)
        let cartAssembly = CartAssembly(servicesAssembler: servicesAssembly, paymentAssembly: paymentAssembly)
        let cartViewController = cartAssembly.build()
        cartViewController.tabBarItem = cartTabBarItem
        
        return UINavigationController(rootViewController: cartViewController)
    }
}
