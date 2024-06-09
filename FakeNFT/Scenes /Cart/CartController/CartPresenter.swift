//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 06.05.2024.
//

import Foundation

protocol CartPresenter {
    func totalPrice() -> String
    func count() -> Int
    func loadOrder()
    func payOrder()
    func getNft(with index: Int) -> Nft
    func getOrderService() -> OrderService
    func getPayService() -> PayService
    func sortCart(filter: CartFilter.FilterBy)
}

final class CartPresenterImpl: CartPresenter {

    weak var viewController: CartViewControllerProtocol?
    private var orderService: OrderService
    private var nftService: NftService
    private var payService: PayService
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

    init(orderService: OrderService, nftService: NftService, payService: PayService) {
        self.orderService = orderService
        self.nftService = nftService
        self.payService = payService
    }

    func totalPrice() -> String {
        var price: Double = 0
        for nft in cartContent {
            price += nft.price
        }
        let moneyText = String(NSString(format: "%.2f", price))
        return moneyText
    }

    func count() -> Int {
        let count: Int = cartContent.count
        return count
    }

    func loadOrder() {
        viewController?.startLoadIndicator()
        orderService.loadOrder { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let order):

                    if !order.nfts.isEmpty {
                        self.cartContent = []
                        self.loadNft(with: order.nfts)

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

    private func loadNft(with ids: [String]) {
        let group = DispatchGroup()

        for id in ids {
            group.enter()
            nftService.loadNft(id: id) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let nft):

                    let contains = self.cartContent.contains { model in
                        return model.id == nft.id
                    }

                    if !contains {
                        self.cartContent.append(nft)
                    }

                case .failure:
                    self.viewController?.stopLoadIndicator()
                    // TODO: add error alert
                }

                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.sortCart(filter: self.currentFilter)
            self.viewController?.updateCart()
            self.viewController?.stopLoadIndicator()
        }
    }

    func getNft(with index: Int) -> Nft {
        cartContent[index]
    }

    func sortCart(filter: CartFilter.FilterBy) {
        currentFilter = filter
        cartContent = cartContent.sorted(by: CartFilter.filter[currentFilter] ?? CartFilter.filterById)
    }

    func getOrderService() -> any OrderService {
        orderService
    }

    func getPayService() -> any PayService {
        payService
    }

    func payOrder() {
        orderService.removeAllNftFromStorage { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let order):
                    self.cartContent = []
                    self.viewController?.stopLoadIndicator()
                    self.viewController?.updateCart()
                case .failure:
                    self.viewController?.stopLoadIndicator()
                    // TODO: add error alert
                }
            }
        }
    }
}
