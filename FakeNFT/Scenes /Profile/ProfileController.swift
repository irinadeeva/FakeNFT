//
//  ProfileController.swift
//  FakeNFT
//
//  Created by Irina Deeva on 03/05/24.
//

import UIKit

final class ProfileViewController: UIViewController {

    let servicesAssembly: ServicesAssembly
    private let profileInput = ProfileDetailInput(id: TokenConstant.id)

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = navigationController?.navigationBar {
            let rightButton = UIBarButtonItem(
                image: UIImage(named: "editNavBar"),
                style: .plain,
                target: self,
                action: #selector(editProfileDetails)
            )
            rightButton.tintColor = .editButton

            navBar.topItem?.rightBarButtonItem = rightButton
        }

        let assembly = ProfileDetailAssembly(servicesAssembler: servicesAssembly)
        let profileDetailViewController = assembly.build(with: profileInput)

        addChild(profileDetailViewController)
        profileDetailViewController.didMove(toParent: self)

        [profileDetailViewController.view].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            profileDetailViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            profileDetailViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileDetailViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileDetailViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func editProfileDetails() {

        let assembly = EditProfileDetailsAssembly(servicesAssembler: servicesAssembly)
        let editProfileDetailsViewController = assembly.build(with: profileInput)
        present(editProfileDetailsViewController, animated: true)
    }
}
