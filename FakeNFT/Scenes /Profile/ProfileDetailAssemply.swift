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

    public func build(with input: ProfileDetailInput) -> UIViewController {
        let presenter = ProfilePresenterImpl(
            input: input,
            service: servicesAssembler.profileService
        )

        let viewController = ProfileDetailsViewController(presenter: presenter)
        presenter.view = viewController

        return viewController
    }
}
