//
//  OrderStorage.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 11.05.2024.
//

import Foundation

protocol OrderStorageProtocol: AnyObject {
    func saveOrder(_ order: Order)
    func getOrder() -> Order?
    func removeOrder()
    func removeNftFromOrder(with id: String)
}

final class OrderStorage: OrderStorageProtocol {

    private var storage: Order?

    private let syncQueue = DispatchQueue(label: "sync-order-queue")

    func saveOrder(_ order: Order) {
        storage = order
    }

    func getOrder() -> Order? {
        storage
    }

    func removeOrder() {
        storage = nil
    }

    func removeNftFromOrder(with id: String) {
        var newNfts: [String] = []

        if let leftNfts = storage?.nfts {
            leftNfts.forEach { string in
                if string != id {
                    newNfts.append(string)
                }
            }
        }

        storage?.nfts = newNfts
    }
}
