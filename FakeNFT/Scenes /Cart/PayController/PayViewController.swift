//
//  PayViewController.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 07.05.2024.
//

import UIKit

protocol PayViewControllerProtocol: AnyObject {
    func updatePayCollection()
    func didSelectCurrency(isEnable: Bool)
    func didPay(payResult: Bool)
    func startLoadIndicator()
    func stopLoadIndicator()
}

protocol PayViewControllerDelegate: AnyObject {
    func didPaid()
}

final class PayViewController: UIViewController, PayViewControllerProtocol, UITextViewDelegate {

    weak var delegate: PayViewControllerDelegate?
    private var presenter: PayPresenterProtocol
    private let agreeUrl = URL(string: "https://yandex.ru/legal/practicum_termsofuse/")

    private lazy var payCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: setupFlowLayout())
        collectionView.register(PayCell.self,
                                forCellWithReuseIdentifier: PayCell.identifier)
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var imagePay: UIView = {
        let imagePay = UIView()
        // TODO: unify color storage
        imagePay.backgroundColor = UIColor(named: "LightGray")
        imagePay.layer.masksToBounds = true
        imagePay.layer.cornerRadius = 12
        imagePay.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        imagePay.translatesAutoresizingMaskIntoConstraints = false
        return imagePay
    }()

    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Совершая покупку, вы соглашаетесь с условиями"
        textLabel.font = .caption2
        // TODO: unify color storage
        textLabel.textColor = UIColor(named: "Black")
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()

    private lazy var agreementTextView: UITextView = {
        let agreementTextView = UITextView()
        let attributedString = NSMutableAttributedString(string: "Пользовательского соглашения")
        let lenOfLink = "Пользовательского соглашения".count

        attributedString.setAttributes([.link: agreeUrl], range: NSRange(location: 0, length: attributedString.length))

        agreementTextView.backgroundColor = .clear
        agreementTextView.attributedText = attributedString
        agreementTextView.isUserInteractionEnabled = true
        agreementTextView.isEditable = false
        // TODO: unify color storage
        agreementTextView.linkTextAttributes = [
            .foregroundColor: UIColor(named: "Blue"),
            .font: UIFont.caption2
        ]
        agreementTextView.delegate = self
        agreementTextView.translatesAutoresizingMaskIntoConstraints = false
        return agreementTextView
    }()

    private lazy var payButton: UIButton = {
        let button = UIButton()
        // TODO: unify color storage
        button.backgroundColor = .black
        button.setTitle("Оплатить", for: .normal)
        // TODO: unify color storage
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .bodyBold
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let loaderView = LoaderView()

    init(presenter: PayPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: unify color storage
        view.backgroundColor = UIColor(named: "White")

        makeNavBar()
        addSubviews()
        setupLayoutImagePay()
        setupLayout()

        presenter.getCurrencies()
    }

    private func makeNavBar() {
        if let navBar = navigationController?.navigationBar {
            navigationItem.title = "Выберите способ оплаты"
            navBar.titleTextAttributes = [.font: UIFont.bodyBold]
            // TODO: unify color storage
            navBar.tintColor = UIColor(named: "Black")

            let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(toCart))
            // TODO: unify color storage
            leftButton.image = UIImage(named: "Back")
        }
    }

    private func addSubviews() {
        view.addSubview(payCollectionView)
        view.addSubview(imagePay)
        imagePay.addSubview(textLabel)
        imagePay.addSubview(agreementTextView)
        imagePay.addSubview(payButton)
    }

    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()

        layout.itemSize = .init(width: 168, height: 46)

        return layout
    }

    private func setupLayoutImagePay() {
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: imagePay.leadingAnchor, constant: 18),
            textLabel.topAnchor.constraint(equalTo: imagePay.topAnchor, constant: 16),

            agreementTextView.heightAnchor.constraint(equalToConstant: 44),
            agreementTextView.topAnchor.constraint(equalTo: imagePay.topAnchor, constant: 32),
            agreementTextView.leadingAnchor.constraint(equalTo: imagePay.leadingAnchor, constant: 14),
            agreementTextView.trailingAnchor.constraint(equalTo: imagePay.trailingAnchor, constant: -16),

            payButton.topAnchor.constraint(equalTo: imagePay.topAnchor, constant: 76),
            payButton.trailingAnchor.constraint(equalTo: imagePay.trailingAnchor, constant: -16),
            payButton.leadingAnchor.constraint(equalTo: imagePay.leadingAnchor, constant: 16),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            payCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            payCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            payCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            imagePay.topAnchor.constraint(equalTo: payCollectionView.bottomAnchor),
            imagePay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagePay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagePay.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imagePay.heightAnchor.constraint(equalToConstant: 154)
        ])
    }

    @objc func toCart() {
        dismiss(animated: true)
    }

    @objc private func didTapPayButton() {
        presenter.payOrder()
    }

    func didSelectCurrency(isEnable: Bool) {
        payButton.isEnabled = isEnable
        payButton.backgroundColor = isEnable ? UIColor(named: "Black") : UIColor(named: "LightGray")
    }

    func updatePayCollection() {
        payCollectionView.reloadData()
    }

    func didPay(payResult: Bool) {
        didSelectCurrency(isEnable: true)
        if payResult {
            let successPayController = SuccessPayController()
            successPayController.modalPresentationStyle = .fullScreen
            delegate?.didPaid()
            present(successPayController, animated: true) {
                self.navigationController?.popViewController(animated: true)
                self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[1]
            }
        } else {
            showPayError()
        }
    }

    func startLoadIndicator() {
        loaderView.showLoading()
    }

    func stopLoadIndicator() {
        loaderView.hideLoading()
    }

    func showPayError() {
        let alert = UIAlertController(title: "", message: "Не удалось произвести оплату", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
            self.dismiss(animated: true)
        }
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.presenter.payOrder()
        }
        alert.addAction(cancelAction)
        alert.addAction(repeatAction)
        self.present(alert, animated: true, completion: nil)
    }

}

extension  PayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return presenter.count()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PayCell.identifier,
            for: indexPath) as? PayCell else {
            return UICollectionViewCell()
        }

        let model = presenter.getModel(indexPath: indexPath)
        cell.updateCell(currency: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PayCell
        cell?.selectCell(wasSelected: true)
        didSelectCurrency(isEnable: true)
        presenter.selectedCurrency = cell?.currency
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PayCell
        cell?.selectCell(wasSelected: false)
    }
}
