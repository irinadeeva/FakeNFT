//
//  nftCollectionTableCell.swift
//  FakeNFT
//
//  Created by Irina Deeva on 11/06/24.
//

import UIKit

final class NftCollectionCell: UITableViewCell {
    static let identifier = "nftCollectionCell"

    // MARK: - UI elements

    private lazy var cover: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var name: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCell() {
        cover.image = UIImage(named: "cover")
        name.text = "Peach (11)"
    }

    private func setupUI() {
        [cover, name].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            cover.topAnchor.constraint(equalTo: contentView.topAnchor),
            cover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cover.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            name.topAnchor.constraint(equalTo: cover.bottomAnchor, constant: 4),
            name.leadingAnchor.constraint(equalTo: cover.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: cover.trailingAnchor)
        ])
    }
}
