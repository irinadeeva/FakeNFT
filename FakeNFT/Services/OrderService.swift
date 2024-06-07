//
//  OrderService.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 11.05.2024.
//

import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void
typealias RemoveOrderCompletion = (Result<[String], Error>) -> Void
typealias RemoveAllNftCompletion = (Result<Int, Error>) -> Void

protocol OrderServiceProtocol {
    var cartPresenter: CartPresenter? { get set}
    var nftsStorage: [Nft] { get }

    func loadOrder(completion: @escaping OrderCompletion)
    func removeNftFromStorage(id: String, completion: @escaping RemoveOrderCompletion)
    func removeAllNftFromStorage(completion: @escaping RemoveAllNftCompletion)
}

final class OrderService: OrderServiceProtocol {

    private let networkClient: NetworkClient
    private let storage: OrderStorageProtocol
    private let nftByIdService: NftByIdServiceProtocol
    private var nftStorage: NftByIdStorageProtocol
    var nftsStorage: [Nft] = []

    var cartPresenter: CartPresenter?

    init(networkClient: NetworkClient, orderStorage: OrderStorageProtocol, nftByIdService: NftByIdServiceProtocol, nftStorage: NftByIdStorageProtocol) {
        self.networkClient = networkClient
        self.storage = orderStorage
        self.nftByIdService = nftByIdService
        self.nftStorage = nftStorage
    }

    func loadOrder(completion: @escaping OrderCompletion) {
        if let order = storage.getOrder() {
            completion(.success(order))
            return
        }

        let request = OrderRequest()
        networkClient.send(request: request, type: Order.self) { [weak storage] result in
            switch result {
            case .success(let order):
                storage?.saveOrder(order)
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func removeNftFromStorage(id: String, completion: @escaping RemoveOrderCompletion) {
        self.nftStorage.removeNftById(with: id)

        let request = ChangeOrderRequest(nfts: Array(self.nftStorage.storage.keys))
        networkClient.send(request: request, type: ChangedOrderDataModel.self) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case let .success(data):
                    self.nftsStorage.removeAll(where: { $0.id == id })
                    self.cartPresenter?.cartContent.removeAll(where: { $0.id == id })
                    self.nftStorage.removeNftById(with: id)

                    self.storage.removeNftFromOrder(with: id)
                    completion(.success(data.nfts))
                case let .failure(error):
                    completion(.failure(error))
                }
            }

        }
        return
    }

    func removeAllNftFromStorage(completion: @escaping RemoveAllNftCompletion) {
        let request = EmptyOrderRequest(nfts: [])

        networkClient.send(request: request, type: ChangedOrderDataModel.self) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case let .success(data):
                    self.nftsStorage.removeAll()
                    self.cartPresenter?.cartContent = []
                    self.cartPresenter?.viewController?.updateCartTable()
                    self.cartPresenter?.viewController?.updateCart()
                    self.nftStorage.removeAllNft()
                    self.storage.removeOrder()
                    completion(.success(data.nfts.count))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
        return
    }
}
