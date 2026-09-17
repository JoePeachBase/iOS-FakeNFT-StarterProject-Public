import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogViewModel = CatalogViewModel(collectionService: servicesAssembly.collectionService)
        let collectionDetailAssembly = CollectionDetailAssembly(serviceAssembly: servicesAssembly)
        let catalogController = CatalogViewController(viewModel: catalogViewModel, collectionDetailAssembly: collectionDetailAssembly)
        let navigationController = UINavigationController(rootViewController: catalogController)
        navigationController.tabBarItem = catalogTabBarItem

        viewControllers = [navigationController]

        view.backgroundColor = .systemBackground
    }
}
