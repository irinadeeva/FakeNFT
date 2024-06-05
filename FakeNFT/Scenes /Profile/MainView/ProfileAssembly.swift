//
//  ProfileAssembly.swift
//  FakeNFT
//
//  Created by Irina Deeva on 05/06/24.
//

import UIKit

final class ProfileAssembly {
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembly = servicesAssembler
    }

    func build() -> UIViewController {
        let presenter = ProfilePresenterImpl(
            profileService: servicesAssembly.profileService,
            nftService: servicesAssembly.nftService
        )

        let viewController = ProfileViewController(presenter: presenter)
        presenter.view = viewController

        return viewController
    }
}
