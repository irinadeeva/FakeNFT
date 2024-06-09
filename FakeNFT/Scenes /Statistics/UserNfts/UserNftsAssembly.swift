import UIKit

final class UserNftsAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    private let networkClient = DefaultNetworkClient()

    private var userNftService: UserNftsServiceProtocol {
        UserNftsService(
            networkClient: networkClient
        )
    }

    func build(with input: [String]) -> UIViewController {
        let presenter = UserNftsPresenter(
            nftsInput: input,
            userNftService: userNftService,
            profileService: servicesAssembler.profileService,
            orderService: servicesAssembler.orderService
        )
        let viewController = UserNftsViewController(presenter: presenter)
        presenter.view = viewController
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
