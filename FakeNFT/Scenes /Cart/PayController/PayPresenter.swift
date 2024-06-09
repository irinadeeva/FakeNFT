//
//  PayPresenter.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 08.05.2024.
//

import UIKit

protocol PayPresenterProtocol {
    var selectedCurrency: CurrencyDataModel? { get set }
    func count() -> Int
    func getModel(indexPath: IndexPath) -> CurrencyDataModel
    func payOrder()
    func getCurrencies()
}

final class PayPresenter: PayPresenterProtocol {

    weak var payController: PayViewControllerProtocol?
    private var currencies: [CurrencyDataModel] = []
    private var payService: PayService?
    var selectedCurrency: CurrencyDataModel? {
        didSet {
            if selectedCurrency != nil {
                payController?.didSelectCurrency(isEnable: true)
            }
        }
    }

    init(payService: PayService) {
        self.payService = payService
    }

    func count() -> Int {
        return currencies.count
    }

    func getModel(indexPath: IndexPath) -> CurrencyDataModel {
        let model = currencies[indexPath.row]
        return model
    }

    func payOrder() {
        payController?.startLoadIndicator()
        guard let selectedCurrency = selectedCurrency else { return }
        payService?.payOrder(currencyId: selectedCurrency.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.payController?.didPay(payResult: data.success)
                self.payController?.stopLoadIndicator()
            case .failure:
                self.payController?.didPay(payResult: false)
                self.payController?.stopLoadIndicator()
            }
        }
    }

    func getCurrencies() {
        payController?.startLoadIndicator()
        payService?.getCurrencies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.currencies = data
                self.payController?.updatePayCollection()
                self.payController?.stopLoadIndicator()
            case let .failure(error):
                self.payController?.stopLoadIndicator()
            }
        }
    }
}
