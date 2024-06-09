//
//  OrderStorage.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 11.05.2024.
//

import Foundation

protocol OrderStorage: AnyObject {
    func saveOrder(_ order: Order)
    func getOrder() -> Order?
}

final class OrderStorageImpl: OrderStorage {

    private var storage: Order?

    private let syncQueue = DispatchQueue(label: "sync-order-queue")

    func saveOrder(_ order: Order) {
        storage = order
    }

    func getOrder() -> Order? {
        storage
    }
}
