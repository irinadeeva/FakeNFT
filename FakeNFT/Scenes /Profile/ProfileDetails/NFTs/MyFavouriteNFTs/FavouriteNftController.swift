//
//  MyFavouriteNFTsController.swift
//  FakeNFT
//
//  Created by Irina Deeva on 12/05/24.
//

import UIKit

final class FavouriteNftViewController: UIViewController {

    internal lazy var activityIndicator = UIActivityIndicatorView()

    private var presenter: NftPresenter

    private lazy var chevronLeft: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left")?
            .withTintColor(.text, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    // TODO: rewrite
    private let nftsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FavouriteNftsCell.self, forCellWithReuseIdentifier: FavouriteNftsCell.identifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас ещё нет избранных NFT"
        label.font = .bodyBold
        label.textColor = .text
        return label
    }()

    private var nfts: [Nft] = []

    // MARK: - Init

    init(presenter: NftPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
        setupUI()

        if nfts.count == 0 {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
            nftsCollection.reloadData()
        }
    }
}

extension FavouriteNftViewController {

    private func setupUI() {
        title = "Избранные NFT"

        let backButton = UIBarButtonItem(customView: chevronLeft)
        navigationItem.leftBarButtonItem = backButton

        nftsCollection.delegate = self
        nftsCollection.dataSource = self

        [emptyLabel, nftsCollection].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            nftsCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            nftsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UserNFTsView

extension FavouriteNftViewController: NftView {
    func fetchNfts(_ nft: [Nft]) {
        self.nfts = nft
        nftsCollection.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension FavouriteNftViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nfts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavouriteNftsCell.identifier,
            for: indexPath) as? FavouriteNftsCell else {
            return UICollectionViewCell()
        }

        let nft = nfts[indexPath.item]
        cell.updateCell(with: nft)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavouriteNftViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 32) / 2
        return CGSize(width: width, height: 108)
    }
}
