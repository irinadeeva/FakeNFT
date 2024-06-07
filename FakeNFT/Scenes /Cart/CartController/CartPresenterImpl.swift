//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 06.05.2024.
//

import Foundation
import UIKit

protocol CartPresenter {
    var cartContent: [Nft] { get set}
    var viewController: CartViewControllerProtocol? { get set}

    func totalPrice() -> Double
    func count() -> Int
    func getOrder()
    func setOrder()
    func getModel(indexPath: IndexPath) -> Nft
    func sortCart(filter: CartFilter.FilterBy)
    func getOrderService() -> OrderServiceProtocol
    func getPayService() -> PayServiceProtocol
}

final class CartPresenterImpl: CartPresenter {

    weak var viewController: CartViewControllerProtocol?
    private var orderService: OrderServiceProtocol
    private var nftByIdService: NftByIdServiceProtocol
    private var payService: PayServiceProtocol
    private var userDefaults = UserDefaults.standard
    private let filterKey = "filter"

    private var currentFilter: CartFilter.FilterBy {
        get {
            let id = userDefaults.integer(forKey: filterKey)
            return CartFilter.FilterBy(rawValue: id) ?? .id
        }
        set {
            userDefaults.setValue(newValue.rawValue, forKey: filterKey)
        }
    }

    var cartContent: [Nft] = []
    var orderIds: [String] = []

//    var order: Order?
//    var nftById: Nft?

    init(orderService: OrderServiceProtocol, nftByIdService: NftByIdServiceProtocol, payService: PayServiceProtocol) {
        self.orderService = orderService
        self.nftByIdService = nftByIdService
        self.payService = payService
        self.orderService.cartPresenter = self
    }

    func totalPrice() -> Double {
        var price: Double = 0
        for nft in cartContent {
            price += nft.price
        }
        return price
    }

    func count() -> Int {
        let count: Int = cartContent.count
        return count
    }

    func getOrder() {
        viewController?.startLoadIndicator()
        orderService.loadOrder { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let order):

                    if !order.nfts.isEmpty {

                        self.getNfts(with: order.nfts)

                    } else {
                        self.viewController?.stopLoadIndicator()
                        self.viewController?.updateCart()
                    }
                case .failure:
                    self.viewController?.stopLoadIndicator()
                    // TODO: add error alert
                }
            }
        }
    }

    private func getNfts(with ids: [String]) {

        for id in ids {
            nftByIdService.loadNft(id: id) { [weak self] result in
                guard let self else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result {
                    case .success(let nft):

                        let contains = self.cartContent.contains {
                            model in
                            return model.id == nft.id
                        }

                        if !contains {
                            self.cartContent.append(nft)
                        }

                        self.viewController?.updateCart()
                        self.viewController?.stopLoadIndicator()
                        self.sortCart(filter: self.currentFilter)
                    case .failure(let error):
                        self.viewController?.stopLoadIndicator()
                        // TODO: add error alert
                    }
                }
            }
        }
    }

    func setOrder() {
        let order = self.orderService.nftsStorage
        self.cartContent = order

        viewController?.updateCartTable()
    }

    func getModel(indexPath: IndexPath) -> Nft {
        let model = cartContent[indexPath.row]
        return model
    }

    func sortCart(filter: CartFilter.FilterBy) {
        currentFilter = filter
        cartContent = cartContent.sorted(by: CartFilter.filter[currentFilter] ?? CartFilter.filterById)
    }

    func getOrderService() -> any OrderServiceProtocol {
        orderService
    }

    func getPayService() -> any PayServiceProtocol {
        payService
    }

    @objc private func didCartSorted(_ notification: Notification) {
        let orderUnsorted = orderService.nftsStorage.compactMap { Nft(nft: $0) }
        cartContent = orderUnsorted.sorted(by: CartFilter.filter[currentFilter] ?? CartFilter.filterById )
    }

}
