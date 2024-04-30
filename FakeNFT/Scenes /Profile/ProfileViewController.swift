//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Irina Deeva on 30/04/24.
//

import UIKit

final class ProfileViewController: UIViewController {
    let servicesAssembly: ServicesAssembly

    private var profileImage: UIImageView!
    private var userName: UILabel!
    private var userDescription: UILabel!
//    private var imageDescriptionName: UIView!
    private var websiteName: UILabel!
    private var editButton: UIButton!
    // my NFTs
    // favourite
    // about

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //square.and.pencil

        setupUI()
    }
}

extension ProfileViewController {
    func setupUI() {
        profileImage = UIImageView()

        userName = UILabel()
        userName.textColor =

        userName.font = .systemFont(ofSize: 23, weight: .semibold)

        userDescription = UILabel()
        userDescription.textColor = .black
        userDescription.font = .systemFont(ofSize: 13)

        editButton = UIButton.systemButton(
            with: UIImage(named: "Exit") ?? UIImage(),
            target: self,
            action: #selector(tapEditButton)
        )
        editButton.tintColor = .black

        [profileImage, editButton, userName, userDescription].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            editButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            userName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            userName.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
//            userNickname.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8),
//            userNickname.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
//            userDescription.topAnchor.constraint(equalTo: userNickname.bottomAnchor, constant: 8),
            userDescription.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor)
        ])
    }

    @objc
    private func tapEditButton() {
//        let alert = AlertModel(
//            title: "Пока, пока!",
//            message: "Уверены, что хотите выйти?",
//            buttonTexts: ["Да", "Нет"]
//        ) { [weak self] index in
//            guard let self else {return}
//
//            if index == 0 {
//                presenter?.logOut()
//            } else {
//                dismiss(animated: true)
//            }
//        }
//
//        alertPresenter?.show(alertModel: alert)
    }
}
