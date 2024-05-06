//
//  ProfileController.swift
//  FakeNFT
//
//  Created by Irina Deeva on 03/05/24.
//

import UIKit

final class ProfileViewController: UIViewController {

    let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let assembly = ProfileDetailAssembly(servicesAssembler: servicesAssembly)
        let profileInput = ProfileDetailInput(id: TokenConstant.id)
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
}
