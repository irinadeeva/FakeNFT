//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 05.05.2024.
//

import Foundation
import UIKit

final class CartViewController: UIViewController {

    var presenter: CartPresenter

    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "sort")
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyOrderCell.self, forCellReuseIdentifier: MyOrderCell.identifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var imagePay: UIView = {
        let imagePay = UIView()
        // TODO: unify color storaga
        imagePay.backgroundColor = UIColor(named: "LightGray")
        imagePay.layer.masksToBounds = true
        imagePay.layer.cornerRadius = 12
        // TODO: read what it this
        imagePay.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner ]
        imagePay.translatesAutoresizingMaskIntoConstraints = false
        return imagePay
    }()

    private lazy var amountLabel: UILabel = {
        let amountLabel = UILabel()
        amountLabel.font = .caption1
        amountLabel.text = "0 NFT"
        // TODO: unify color storage
        amountLabel.textColor = UIColor(named: "Black")
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        return amountLabel
    }()

    private lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.font = .bodyBold
        moneyLabel.text = "0,00 ETH"
        // TODO: unify color storage
        moneyLabel.textColor = UIColor(named: "Green")
        moneyLabel.translatesAutoresizingMaskIntoConstraints = false
        return moneyLabel
    }()

    private lazy var payButton: UIButton = {
        let button = UIButton()
        // TODO: unify color storage
        button.backgroundColor =  UIColor(named: "Black")
        button.setTitle("К оплате", for: .normal)
        // TODO: unify color storage
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .bodyBold
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина пуста"
        label.font = .bodyBold
        // TODO: unify color storage
        label.textColor = UIColor(named: "Black")
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // TODO: use from Common via protocol
    private let activityIndicator = LoaderView()

    // MARK: - Init

    init(presenter: CartPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.loadOrder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background

        addSubviews()
        setupLayoutImagePay()
        setupLayout()
        setupNavigationBar()
    }

    // MARK: - Private

    @objc private func didTapSortButton() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "По цене", style: .default, handler: { [weak self] (_) in
            guard let self = self else { return }
            self.presenter.sortCart(filter: .price)
            self.tableView.reloadData()

            UserDefaults.standard.set("Цена", forKey: "Sort")
            UserDefaults.standard.synchronize()
        }))

        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default, handler: { [weak self] (_) in
            guard let self = self else { return }
            self.presenter.sortCart(filter: .rating)
            self.tableView.reloadData()

            UserDefaults.standard.set("Рейтинг", forKey: "Sort")
            UserDefaults.standard.synchronize()
        }))

        alert.addAction(UIAlertAction(title: "По названию", style: .default, handler: { [weak self] (_) in
            guard self != nil else { return }
            guard let self = self else { return }
            self.presenter.sortCart(filter: .title)
            self.tableView.reloadData()

            UserDefaults.standard.set("Название", forKey: "Sort")
            UserDefaults.standard.synchronize()
        }))

        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: { (_) in
        }))

        self.present(alert, animated: true)
    }

    @objc private func didTapPayButton() {
//        let presenter = PayPresenter(
//            payService: presenter.getPayService(),
//            orderService: presenter.getOrderService()
//        )
//
//        let payController = PayViewController(presenter: presenter, cartController: self)
//        presenter.payController = payController
//
//        payController.hidesBottomBarWhenPushed = true
//        navigationItem.backButtonTitle = ""
//        navigationController?.pushViewController(payController, animated: true)
    }

    private func addSubviews() {
        [amountLabel, moneyLabel, payButton].forEach {
            imagePay.addSubview($0)
        }

        [tableView, imagePay, emptyCartLabel, activityIndicator].forEach {
            view.addSubview($0)
        }
    }

    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        let rightButton = UIBarButtonItem(
            image: UIImage(named: "sort"),
            style: .plain,
            target: self,
            action: #selector(didTapSortButton)
        )

        // TODO: unify color storage
        rightButton.tintColor = UIColor(named: "Black")
        navigationBar.topItem?.rightBarButtonItem = rightButton
    }

    private func setupLayoutImagePay() {
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: imagePay.leadingAnchor, constant: 16),
            amountLabel.topAnchor.constraint(equalTo: imagePay.topAnchor, constant: 16),

            moneyLabel.leadingAnchor.constraint(equalTo: imagePay.leadingAnchor, constant: 16),
            moneyLabel.bottomAnchor.constraint(equalTo: imagePay.bottomAnchor, constant: -16),

            payButton.trailingAnchor.constraint(equalTo: imagePay.trailingAnchor, constant: -16),
            payButton.centerYAnchor.constraint(equalTo: imagePay.centerYAnchor),
            payButton.widthAnchor.constraint(equalToConstant: 240),
            payButton.heightAnchor.constraint(equalToConstant: 44),

            emptyCartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupLayout() {
        activityIndicator.constraintCenters(to: view)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            imagePay.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            imagePay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagePay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagePay.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -83),
            imagePay.heightAnchor.constraint(equalToConstant: 76)
        ])
    }
}

extension CartViewController: CartViewControllerProtocol {
    func updateCart() {
        if presenter.count() == 0 {
            emptyCartLabel.isHidden = false
            imagePay.isHidden = true
        } else {
            emptyCartLabel.isHidden = true
            imagePay.isHidden = false
            let count = presenter.count()
            let moneyText = presenter.totalPrice()
            moneyLabel.text = "\(moneyText) ETH"
            amountLabel.text = "\(count) NFT"
            tableView.reloadData()
        }
    }

    func updateCartTable() {
        tableView.reloadData()
    }

    func startLoadIndicator() {
        activityIndicator.showLoading()
    }

    func stopLoadIndicator() {
        activityIndicator.hideLoading()
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.count()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyOrderCell.identifier,
            for: indexPath) as? MyOrderCell else {
            return UITableViewCell()
        }
        let model = presenter.getNft(with: indexPath.row)
        cell.delegate = self
        cell.updateCell(with: model)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension CartViewController: CartTableViewCellDelegate {
    func didTapDeleteButton(id: String, image: UIImage) {

//        let deletePresenter = DeleteCardPresenter(orderService: presenter.getOrderService(),
//                                                  nftIdForDelete: id)
//
//        let deleteViewController = DeleteCardViewController(presenter: deletePresenter,
//                                                            cartContrroller: self,
//                                                            nftImage: image)
//        deletePresenter.viewController = deleteViewController
//
//        deleteViewController.modalPresentationStyle = .overCurrentContext
//        self.tabBarController?.present(deleteViewController, animated: true)
    }
}
