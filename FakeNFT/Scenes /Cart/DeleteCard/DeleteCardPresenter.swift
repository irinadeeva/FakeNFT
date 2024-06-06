//
//  DeleteCardPresenter.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 09.05.2024.
//

import Foundation
import UIKit

protocol DeleteCardPresenterProtocol {

//    var nftImage: UIImage { get }
    func deleteNFTfromCart(completion: @escaping (Result<[String], Error>) -> Void)
}

final class DeleteCardPresenter: DeleteCardPresenterProtocol {

    weak var viewController: CartDeleteControllerProtocol?
    private var orderService: OrderServiceProtocol
    private var nftIdForDelete: String

    init(orderService: OrderServiceProtocol, nftIdForDelete: String) {
        self.orderService = orderService
        self.nftIdForDelete = nftIdForDelete
    }

    func deleteNFTfromCart(completion: @escaping (Result<[String], Error>) -> Void) {
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
