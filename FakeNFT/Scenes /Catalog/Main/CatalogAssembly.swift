//
//  CatalogAssembly.swift
//  FakeNFT
//
//  Created by Irina Deeva on 11/06/24.
//

import UIKit

final class CatalogAssembly {
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func build() -> UIViewController {
        let presenter = CatalogPresenterImpl(
            services: servicesAssembly
        )

        let viewController = CatalogViewController(presenter: presenter)
        presenter.view = viewController

        return viewController
    }
}
