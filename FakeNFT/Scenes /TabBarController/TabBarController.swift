import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly?

    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(systemName: "person.crop.circle.fill"),
        tag: 0
    )

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 1
    )

    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "cart"),
        tag: 2
    )

    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 3
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let servicesAssembly else {
            return
        }

        let statisticsAsssembly = StatisticsAssembly(servicesAssembler: servicesAssembly)
        let statisticsController = UINavigationController(rootViewController: statisticsAsssembly.build())
        statisticsController.tabBarItem = statisticsTabBarItem

        let profileAssembly = ProfileAssembly(servicesAssembler: servicesAssembly)
        let profileController = UINavigationController(rootViewController: profileAssembly.build())
        profileController.tabBarItem = profileTabBarItem

        let catalogController = TestCatalogViewController(servicesAssembly: servicesAssembly)
        catalogController.tabBarItem = catalogTabBarItem

        let cartController = CartViewController(servicesAssembly: servicesAssembly)
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        cartController.tabBarItem = cartTabBarItem

        viewControllers = [profileController, catalogController, cartNavigationController, statisticsController]
    }
}
