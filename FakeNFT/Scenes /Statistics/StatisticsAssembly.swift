import UIKit

final class StatisticsAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    func build() -> UIViewController {
        let presenter = StatisticsPresenter(
            services: servicesAssembler
        )
        let viewController = StatisticsViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
