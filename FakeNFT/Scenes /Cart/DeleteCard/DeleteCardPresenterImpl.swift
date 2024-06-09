//
//  DeleteCardPresenter.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 09.05.2024.
//

import Foundation

protocol DeleteCardPresenter {
    func deleteNftFromCart(completion: @escaping (Result<[String], Error>) -> Void)
}

final class DeleteCardPresenterImpl: DeleteCardPresenter {

    weak var viewController: CartDeleteControllerProtocol?
    private var orderService: OrderServiceProtocol
    private var nftIdForDelete: String

    init(orderService: OrderServiceProtocol, nftIdForDelete: String) {
        self.orderService = orderService
        self.nftIdForDelete = nftIdForDelete
    }

    func deleteNftFromCart(completion: @escaping (Result<[String], Error>) -> Void) {
        viewController?.startLoadIndicator()
        orderService.removeNftFromStorage(id: nftIdForDelete, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.viewController?.stopLoadIndicator()
                completion(.success(data))
            case let .failure(error):
                self.viewController?.showNetworkError(message: "\(error)")
                self.viewController?.stopLoadIndicator()
            }
        })
    }

}
