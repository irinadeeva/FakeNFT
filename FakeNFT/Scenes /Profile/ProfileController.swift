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

        // TODO: check the color
        view.backgroundColor = .systemBackground

        let assembly = ProfileDetailAssembly(servicesAssembler: servicesAssembly)
        let profileInput = ProfileDetailInput(id: Constants.id)
        let profileDetailViewController = assembly.build(with: profileInput)

        addChild(profileDetailViewController)
//        profileDetailViewController.didMove(toParent: self)

        [profileDetailViewController.view].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

// TODO: where to store?
private enum Constants {
    static let id = "20a4069e-6e51-4477-894a-e6fdc9a4bb95"
}
