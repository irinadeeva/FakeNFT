//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Irina Deeva on 30/04/24.
//

import UIKit
import Kingfisher

protocol ProfileDetailsView: AnyObject, ErrorView, LoadingView {
    func fetchProfileDetails(_ profile: Profile)
}

final class ProfileDetailsViewController: UIViewController {

    internal lazy var activityIndicator = UIActivityIndicatorView()

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

    private lazy var userWebsite: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .caption1
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.yaBlueUniversal, for: .normal)
        button.addTarget(self, action: #selector(openWebsite), for: .touchUpInside)
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    // MARK: - Init

    init(presenter: ProfileDetailsPresenterImpl) {
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
        [profileImage, userName, userDescription, userWebsite, tableView].forEach {
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
            userDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            userWebsite.topAnchor.constraint(equalTo: userDescription.bottomAnchor, constant: 12),
            userWebsite.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),

            tableView.topAnchor.constraint(equalTo: userWebsite.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func openWebsite() {
        let webView = WebViewViewController(userWebsiteAbsoluteString: userWebsite.currentTitle)
        present(webView, animated: true)
    }
}

// MARK: - ProfileDetailsView

extension ProfileDetailsViewController: ProfileDetailsView {

    func fetchProfileDetails(_ profile: Profile) {
        userName.text = profile.userName
        userDescription.text = profile.description
        userWebsite.setTitle(profile.userWebsite.absoluteString, for: .normal)

        if profile.imageURL != nil {

            let processor = RoundCornerImageProcessor(cornerRadius: 61)
            let placeholder = UIImage(named: "ProfileStub")

            profileImage.kf.indicatorType = .activity

            profileImage.kf.setImage(
                with: profile.imageURL,
                placeholder: placeholder,
                options: [.processor(processor),
                          .cacheMemoryOnly
                ]
            )
        } else {
            profileImage.image = UIImage(named: "AvatarStub")
        }

        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension ProfileDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileTableViewCell.identifier,
            for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }

        let label = presenter.fetchTitleForCell(with: indexPath)
        cell.configureCell(text: label)

        return cell
    }

}

// MARK: - UITableViewDelegate

extension ProfileDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:

            let userNFTsPresenter = presenter.fetchUserNFTsPresenter()
            let view = UserNftViewController(presenter: userNFTsPresenter)
            userNFTsPresenter.view = view
            view.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(view, animated: true)
        case 1:
            // TODO: this whole section
            let myFavouriteNFTsView = MyFavouriteNFTsController()
            myFavouriteNFTsView.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(myFavouriteNFTsView, animated: true)
        case 2:
            let webView = WebViewViewController(userWebsiteAbsoluteString: userWebsite.currentTitle)
            webView.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(webView, animated: true)
        default:
            return
        }
    }
}