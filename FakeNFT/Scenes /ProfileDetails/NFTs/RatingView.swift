import UIKit

final class RatingView: UIView {

    private var starStackView: UIStackView = {
        var starView = UIStackView()
        starView.axis = .horizontal
        starView.distribution = .fill
        starView.alignment = .leading
        starView.spacing = 2
        return starView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(starStackView)

        NSLayoutConstraint.activate([
            starStackView.topAnchor.constraint(equalTo: topAnchor),
            starStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            starStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            starStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func setStar(with rating: Int) {
        removeAllArrangedSubviews()
        var index = 0
        repeat {
            let view = UIImageView()
            starStackView.addArrangedSubview(view)
            view.image = index < rating ? UIImage(named: "starGold") : UIImage(named: "starGrey")
            index += 1
        }
         while index < 5
    }

    func removeAllArrangedSubviews() {
        starStackView.arrangedSubviews.forEach {
            starStackView.removeArrangedSubview($0)
        }
    }
}
