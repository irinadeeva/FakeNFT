//
//  ProfileViewPresenter.swift
//  FakeNFT
//
//  Created by Irina Deeva on 03/05/24.
//

import Foundation

// MARK: - Protocol

protocol ProfilePresenter {
    func viewDidLoad()
}

// MARK: - State

enum ProfileDetailState {
    case initial, loading, failed(Error), data(Profile)
}

final class ProfilePresenterImpl: ProfilePresenter {
    
    // MARK: - Properties
    
    weak var view: ProfileDetailsView?
    private let input: ProfileDetailInput
    private let service: ProfileService
    private var state = ProfileDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Init
    
    init(input: ProfileDetailInput, service: ProfileService) {
        self.input = input
        self.service = service
    }
    
    // MARK: - Functions
    
    func viewDidLoad() {
        state = .loading
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadProfile()
        case .data(let profile):
            view?.updateProfile(profile)
            view?.hideLoading()
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }
    
    private func loadProfile() {
        service.loadProfile(id: input.id) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.state = .data(profile)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        
        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
}
