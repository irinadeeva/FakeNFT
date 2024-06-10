import Foundation

typealias UserInfoCompletion = (Result<UserInfo, Error>) -> Void

// MARK: - Protocol
protocol UserInfoService {
    func loadUserInfo(with id: String, completion: @escaping UserInfoCompletion)
}

final class UserInfoServiceImpl: UserInfoService {

    private let storage: UserInfoStorage
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient, storage: UserInfoStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadUserInfo(with id: String, completion: @escaping UserInfoCompletion) {

        let request = UserInfoRequest(id: id)

        networkClient.send(request: request, type: UserInfo.self) { [weak storage] result in
            switch result {
            case .success(let user):
                storage?.saveUserInfo(user)
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
