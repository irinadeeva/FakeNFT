//
//  OrderService.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 11.05.2024.
//

import Foundation

typealias OrderCompletion = (Result<OrderDataModel, Error>) -> Void


protocol OrderServiceProtocol {
    var nftsStorage: [NftDataModel] { get }
    
    func loadOrder(completion: @escaping OrderCompletion)
}

final class OrderService: OrderServiceProtocol {
    
    private let networkClient: NetworkClient
    private let orderStorage: OrderStorageProtocol
    private let nftByIdService: NftByIdServiceProtocol
    private var nftStorage: NftByIdStorageProtocol
    private var idsStorage: [String] = []
    var nftsStorage: [NftDataModel] = []

    
    init(networkClient: NetworkClient, orderStorage: OrderStorageProtocol, nftByIdService: NftByIdServiceProtocol, nftStorage: NftByIdStorageProtocol) {
        self.networkClient = networkClient
        self.orderStorage = orderStorage 
        self.nftByIdService = nftByIdService
        self.nftStorage = nftStorage
    }

    func loadOrder(completion: @escaping OrderCompletion) {
        let request = OrderRequest(id: "1")
        networkClient.send(request: request, type: OrderDataModel.self) { [weak orderStorage] result in
            switch result {
            case .success(let order):
                orderStorage?.saveOrder(order)
                self.idsStorage.append(contentsOf: order.nfts)
                for nftId in order.nfts {
                    self.nftByIdService.loadNft(id: nftId) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case let .success(nft):
                            self.nftStorage.saveNftById(nft)
                            let contains = self.nftsStorage.contains {
                                model in
                                return model.id == nft.id
                            }
                            if !contains {
                                self.nftsStorage.append(nft)
                            }
                        case let .failure(error):
                            print(error)
                            completion(.failure(error))
                        }
                    }
                }
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
