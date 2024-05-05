//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Irina Deeva on 30/04/24.
//

import UIKit
import Kingfisher

protocol ProfileDetailsView: AnyObject, ErrorView, LoadingView {
    func updateProfile(_ profile: Profile)
}

final class ProfileDetailsViewController: UIViewController {

    private let presenter: ProfilePresenter

    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var userName: UILabel = {
        let label = UILabel()
        label.textColor = .text
        label.font = .headline3
        label.lineBreakMode =  .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private lazy var userDescription: UILabel = {
        let label = UILabel()
        label.textColor = .text
        label.font = .caption2
        label.lineBreakMode =  .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    internal lazy var activityIndicator = UIActivityIndicatorView()

    // MARK: - Init

    init(presenter: ProfilePresenterImpl) {
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

extension ProfileDetailsViewController {

    // MARK: - Private

    private func setupUI() {
        [profileImage, userName, userDescription].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            userName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16),
            userName.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            userName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            userDescription.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            userDescription.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            userDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - ProfileDetailsView

extension ProfileDetailsViewController: ProfileDetailsView {

    func updateProfile(_ profile: Profile) {
        userName.text = profile.userName
        userDescription.text = profile.description

        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        let placeholder = UIImage(named: "Stub")

        profileImage.kf.indicatorType = .activity

        profileImage.kf.setImage(
            with: profile.profileImage,
            placeholder: placeholder,
            options: [.processor(processor),
                      .cacheMemoryOnly
            ]
        )
    }
}
