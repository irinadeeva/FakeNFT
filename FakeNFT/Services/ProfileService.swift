//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Irina Deeva on 03/05/24.
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func loadProfile(completion: @escaping ProfileCompletion)
    func uploadProfile(with profileToUpload: ProfileToUpload, completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {

    private let networkClient: NetworkClient
    private let storage: ProfileStorage

    init(networkClient: NetworkClient, storage: ProfileStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadProfile(completion: @escaping ProfileCompletion) {
        if let profile = storage.getProfile() {
            completion(.success(profile))
            return
        }

        let request = ProfileRequest(httpMethod: .get)
        networkClient.send(request: request, type: Profile.self) { [weak storage] result in
            switch result {
            case .success(let profile):
                storage?.saveProfile(profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func uploadProfile(with profileToUpload: ProfileToUpload, completion: @escaping ProfileCompletion) {
        guard let profile = storage.getProfile() else {
            return
        }

        if profile.name != profileToUpload.name ||
           profile.description != profileToUpload.description ||
           profile.avatar != profileToUpload.avatar ||
           profile.website != profileToUpload.website {

            let updatedProfile = Profile(id: profile.id,
                                         name: profileToUpload.name,
                                         avatar: profileToUpload.avatar,
                                         description: profileToUpload.description,
                                         nfts: profile.nfts,
                                         website: profileToUpload.website,
                                         likes: profile.likes)

            let bodyString = updatedProfile.toFormData()
            guard let bodyData = bodyString.data(using: .utf8) else { return }

            let request = ProfileRequest(httpMethod: .put, dto: bodyData)

            networkClient.send(request: request, type: Profile.self) { [weak storage] result in
                switch result {
                case .success(let profile):
                    storage?.saveProfile(profile)
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.success(profile))
            return
        }
    }
}
