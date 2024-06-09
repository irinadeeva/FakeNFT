//
//  OrderService.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 11.05.2024.
//

import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void

// MARK: - Protocol
protocol OrderService {
    func getOrder(completion: @escaping OrderCompletion)
    func putOrder(nfts: [String], completion: @escaping OrderCompletion)
    func removeNftFromOrder(id: String, completion: @escaping OrderCompletion)
}

final class OrderServiceImpl: OrderService {

    private let networkClient: NetworkClient
    private let storage: OrderStorage

    init(networkClient: NetworkClient, orderStorage: OrderStorage) {
        self.networkClient = networkClient
        self.storage = orderStorage
    }

    func getOrder(completion: @escaping OrderCompletion) {
        if let order = storage.getOrder() {
            completion(.success(order))
            return
        }

        let request = GetOrdersRequest()
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

    func putOrder(nfts: [String], completion: @escaping OrderCompletion) {

        let request = PutOrdersRequest(nfts: nfts)

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

    func removeNftFromOrder(id: String, completion: @escaping OrderCompletion) {
        let order = storage.getOrder()

        let leftNfts = order?.nfts.filter {
            $0 != id
        }

        let request = PutOrdersRequest(nfts: leftNfts ?? [])

        networkClient.send(request: request, type: Order.self) { [weak storage] result in
            switch result {
            case let .success(order):
                storage?.saveOrder(order)
                completion(.success(order))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
