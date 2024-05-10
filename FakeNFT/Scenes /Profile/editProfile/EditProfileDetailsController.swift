//
//  EditProfileDetails.swift
//  FakeNFT
//
//  Created by Irina Deeva on 08/05/24.
//

import UIKit

protocol EditProfileDetailsView: AnyObject, ErrorView, LoadingView {
    func fetchProfile(_ profile: Profile)
}

final class EditProfileDetailsViewController: UIViewController {

    internal lazy var activityIndicator = UIActivityIndicatorView()

    private let presenter: EditProfileDetailsPresenter

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .closeButton
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()

    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AvatarStub")
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя"
        label.textColor = .text
        label.font = .headline3
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.textColor = .text
        label.font = .headline3
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.text = "Сайт"
        label.textColor = .text
        label.font = .headline3
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .textField
        textField.layer.cornerRadius = 12
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.textAlignment = .left
        return textField
    }()

    // MARK: - Init

    init(presenter: EditProfileDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }
}

extension EditProfileDetailsViewController {

    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = .background

        [closeButton, profileImage, nameLabel, descriptionLabel, websiteLabel, userNameTextField].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            profileImage.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 22),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            userNameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            userNameTextField.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            userNameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),

            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 24)
        ])
    }

    @objc
    private func close() {
        dismiss(animated: true)
    }
}

// MARK: - EditProfileDetailsView

extension EditProfileDetailsViewController: EditProfileDetailsView {

    func fetchProfile(_ profile: Profile) {
        userNameTextField.text = profile.userName
    }
}
