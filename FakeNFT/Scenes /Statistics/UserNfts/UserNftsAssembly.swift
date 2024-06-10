import UIKit

final class UserNftsAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    func build(with input: [String]) -> UIViewController {
        let presenter = UserNftsPresenter(
            nftsInput: input,
            nftService: servicesAssembler.nftService,
            profileService: servicesAssembler.profileService,
            orderService: servicesAssembler.orderService
        )
        let viewController = UserNftsViewController(presenter: presenter)
        presenter.view = viewController
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
