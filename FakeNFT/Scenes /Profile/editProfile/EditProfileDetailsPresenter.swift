//
//  EditProfileDetailsPresenter.swift
//  FakeNFT
//
//  Created by Irina Deeva on 09/05/24.
//

import Foundation

protocol EditProfileDetailsPresenter {
    func viewDidLoad()
}

final class EditProfileDetailsPresenterImpl: EditProfileDetailsPresenter {

    // MARK: - Properties
    weak var view: EditProfileDetailsView?
    private let input: ProfileDetailInput
    private let service: ProfileService

    // MARK: - Init

    init(input: ProfileDetailInput, service: ProfileService) {
        self.input = input
        self.service = service
    }

    // MARK: - Functions

    func viewDidLoad() {

    }
}
