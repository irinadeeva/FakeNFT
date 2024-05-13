import UIKit
import Kingfisher

final class NftCell: UITableViewCell {

    static let identifier = "NftCell"
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

    private lazy var authorNftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = "От John Doe"
        label.textColor = .text
        return label
    }()

    private lazy var starImageView: RatingView = {
        let starImageView = RatingView()
        return starImageView
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.text = "Цена"
        label.textColor = .text
        return label
    }()

    private lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .text
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCell(with model: NftDataModel) {
        var imageData: UIImage

        if UIImage(named: model.images.first!) == nil {
            imageData = UIImage(named: "NFT card") ?? UIImage()
        } else {
            imageData = UIImage(named: model.images.first!)!
        }
        cardImageView.image = imageData

        nftNameLabel.text = model.name
        starImageView.setStar(with: model.rating)
        moneyLabel.text = "\(model.price) ETH"
        likeView.image = UIImage(named: "Unfauvorite") ?? UIImage()
        self.id = model.id
    }
}

extension NftCell {
    private func setupUI() {
        contentView.addSubview(cardView)

        cardImageView.addSubview(likeView)

        [cardView, cardImageView, likeView, nftNameLabel, starImageView, authorNftNameLabel, priceLabel, moneyLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [cardImageView, nftNameLabel, starImageView, authorNftNameLabel, priceLabel, moneyLabel].forEach {
            cardView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(equalToConstant: 108),
            cardView.widthAnchor.constraint(equalToConstant: 203),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            cardImageView.heightAnchor.constraint(equalToConstant: 108),
            cardImageView.widthAnchor.constraint(equalToConstant: 108),
            cardImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),

            likeView.heightAnchor.constraint(equalToConstant: 40),
            likeView.widthAnchor.constraint(equalToConstant: 40),
            likeView.topAnchor.constraint(equalTo: cardImageView.topAnchor),
            likeView.trailingAnchor.constraint(equalTo: cardImageView.trailingAnchor),

            nftNameLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 20),
            nftNameLabel.bottomAnchor.constraint(equalTo: starImageView.topAnchor, constant: -8),

            starImageView.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            starImageView.centerYAnchor.constraint(equalTo: cardImageView.centerYAnchor),

            authorNftNameLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 8),
            authorNftNameLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),

            priceLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 137),
            priceLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 33),

            moneyLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            moneyLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8)
        ])
    }
}
