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

    private lazy var likeImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()

    private lazy var nameCardLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
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

        nameCardLabel.text = model.name
        starImageView.setStar(with: model.rating)
        moneyLabel.text = "\(model.price) ETH"
        self.id = model.id
    }
}

extension NftCell {
    private func setupUI() {
        contentView.addSubview(cardView)

        cardImageView.addSubview(likeImageView)

        [cardView, cardImageView, likeImageView, nameCardLabel, starImageView, priceLabel, moneyLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [cardImageView, nameCardLabel, starImageView, priceLabel, moneyLabel].forEach {
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

            likeImageView.heightAnchor.constraint(equalToConstant: 40),
            likeImageView.widthAnchor.constraint(equalToConstant: 40),
            likeImageView.topAnchor.constraint(equalTo: cardImageView.topAnchor),
            likeImageView.trailingAnchor.constraint(equalTo: cardImageView.trailingAnchor),

            nameCardLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 20),
            nameCardLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),

            starImageView.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 20),
            starImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 34),

            priceLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 20),
            priceLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 58),

            moneyLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 20),
            moneyLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 78)
        ])
    }
}
