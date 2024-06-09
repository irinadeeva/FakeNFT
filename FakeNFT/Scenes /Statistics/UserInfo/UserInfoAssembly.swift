import UIKit

final class UserInfoAssembly {
    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    func build(with input: String) -> UIViewController {
        let presenter = UserInfoPresenter(
            userID: input,
            services: servicesAssembler
        )
        let viewController = UserInfoViewController(presenter: presenter)
        presenter.view = viewController
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
