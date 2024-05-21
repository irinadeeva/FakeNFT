import UIKit
import Kingfisher

final class FavouriteNftsCell: UICollectionViewCell {

    static let identifier = "FavouriteNftCell"

    private var id: String?

    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var likeView: UIImageView = {
        let image = UIImageView()
        return image
    }()

    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .text
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var starImageView: RatingView = {
        let starImageView = RatingView()
        return starImageView
    }()

    private lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .text
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCell(with nft: Nft) {
        let processor = RoundCornerImageProcessor(cornerRadius: 61)

        cardImageView.kf.indicatorType = .activity

        cardImageView.kf.setImage(
            with: nft.images.first,
            options: [.processor(processor),
                      .cacheMemoryOnly
            ]
        )

        nftNameLabel.text = nft.name
        starImageView.setStar(with: nft.rating)
        moneyLabel.text = "\(nft.price) ETH"
        likeView.image = UIImage(named: "Favourite") ?? UIImage()
    }
}

extension FavouriteNftsCell {
    private func setupUI() {
        cardImageView.addSubview(likeView)
        likeView.translatesAutoresizingMaskIntoConstraints = false

        [cardImageView, nftNameLabel, starImageView, moneyLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            cardImageView.heightAnchor.constraint(equalToConstant: 80),
            cardImageView.widthAnchor.constraint(equalToConstant: 80),
            cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            likeView.heightAnchor.constraint(equalToConstant: 30),
            likeView.widthAnchor.constraint(equalToConstant: 30),
            likeView.topAnchor.constraint(equalTo: cardImageView.topAnchor),
            likeView.trailingAnchor.constraint(equalTo: cardImageView.trailingAnchor),

            nftNameLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 12),
            nftNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nftNameLabel.bottomAnchor.constraint(equalTo: starImageView.topAnchor, constant: -8),

            starImageView.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            starImageView.centerYAnchor.constraint(equalTo: cardImageView.centerYAnchor),

            moneyLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            moneyLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 8)
        ])
    }
}
