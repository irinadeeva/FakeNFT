//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Irina Deeva on 11/06/24.
//

import UIKit

final class CatalogViewController: UIViewController {
    let presenter: CatalogPresenter

    // MARK: - UI elements
    private lazy var nftCollectionTable: UITableView = {
        let tableView = UITableView()
        tableView.register(NftCollectionCell.self, forCellReuseIdentifier: NftCollectionCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Init

    init(presenter: CatalogPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension CatalogViewController {
    private func setupUI() {
        view.backgroundColor = .background
        [nftCollectionTable].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            nftCollectionTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            nftCollectionTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollectionTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CatalogViewController: CatalogView {

}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NftCollectionCell.identifier,
            for: indexPath) as? NftCollectionCell else {
            return UITableViewCell()
        }

        cell.updateCell()
        return cell
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
