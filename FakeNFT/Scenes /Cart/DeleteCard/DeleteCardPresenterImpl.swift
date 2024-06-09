//
//  DeleteCardPresenter.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 09.05.2024.
//

import Foundation

protocol DeleteCardPresenter {
    func deleteNftFromCart()
}

final class DeleteCardPresenterImpl: DeleteCardPresenter {

    weak var viewController: CartDeleteControllerProtocol?
    private var orderService: OrderServiceProtocol
    private var nftIdForDelete: String

    init(orderService: OrderServiceProtocol, nftIdForDelete: String) {
        self.orderService = orderService
        self.nftIdForDelete = nftIdForDelete
    }

    func deleteNftFromCart() {
        viewController?.startLoadIndicator()

        orderService.removeNftFromStorage(id: nftIdForDelete, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(data):
                self.viewController?.stopLoadIndicator()
                self.viewController?.dismissView()
            case let .failure(error):
                self.viewController?.stopLoadIndicator()
                self.viewController?.showNetworkError(message: "\(error)")
            }
        })
    }

}
