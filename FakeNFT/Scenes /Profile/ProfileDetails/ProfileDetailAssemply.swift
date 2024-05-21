//
//  ProfileAssemply.swift
//  FakeNFT
//
//  Created by Irina Deeva on 03/05/24.
//

import UIKit

public final class ProfileDetailAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    func build() -> UIViewController {
        let presenter = ProfileDetailsPresenterImpl(
            profileService: servicesAssembler.profileService,
            nftService: servicesAssembler.nftService
        )

        let viewController = ProfileDetailsViewController(presenter: presenter)
        presenter.view = viewController

        return viewController
    }
}
