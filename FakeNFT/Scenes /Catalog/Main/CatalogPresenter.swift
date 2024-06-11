//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Irina Deeva on 11/06/24.
//

import Foundation

final class CatalogPresenterImpl: CatalogPresenter {
    weak var view: CatalogView?
    let services: ServicesAssembly

    init(services: ServicesAssembly) {
        self.services = services
    }
}
