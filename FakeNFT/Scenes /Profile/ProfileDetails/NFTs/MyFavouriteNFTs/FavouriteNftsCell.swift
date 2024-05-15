import UIKit
import Kingfisher

final class FavouriteNftsCell: UICollectionViewCell {

    static let identifier = "FavouriteNftCell"
    private var id: String?

    private lazy var cardView: UIView = {
        let view = UIView()
        return view
    }()

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
        contentView.addSubview(cardView)

        cardImageView.addSubview(likeView)

        [cardView,
         cardImageView,
         likeView,
         nftNameLabel,
         starImageView,
         moneyLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [cardImageView, nftNameLabel, starImageView, moneyLabel].forEach {
            cardView.addSubview($0)
        }

        NSLayoutConstraint.activate([
//            cardView.heightAnchor.constraint(equalToConstant: 108),
//            cardView.widthAnchor.constraint(equalToConstant: 168),

            cardImageView.heightAnchor.constraint(equalToConstant: 80),
            cardImageView.widthAnchor.constraint(equalToConstant: 80),
            cardImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),

            likeView.heightAnchor.constraint(equalToConstant: 30),
            likeView.widthAnchor.constraint(equalToConstant: 30),
            likeView.topAnchor.constraint(equalTo: cardImageView.topAnchor),
            likeView.trailingAnchor.constraint(equalTo: cardImageView.trailingAnchor),

            nftNameLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 12),
            nftNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            nftNameLabel.bottomAnchor.constraint(equalTo: starImageView.topAnchor, constant: -8),

            starImageView.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            starImageView.centerYAnchor.constraint(equalTo: cardImageView.centerYAnchor),

            moneyLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            moneyLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 8)
        ])
    }
}