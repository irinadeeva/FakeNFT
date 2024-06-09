final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let usersStorage: UsersStorage
    private let profileStorage: ProfileStorage
    private let orderStorage: OrderStorageProtocol

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        usersStorage: UsersStorage,
        profileStofare: ProfileStorage,
        orderStorage: OrderStorageProtocol
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.usersStorage = usersStorage
        self.profileStorage = profileStofare
        self.orderStorage = orderStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var statisticsService: UsersServiceProtocol {
        UsersService(
            networkClient: networkClient,
            storage: usersStorage
        )
    }

    var profileService: ProfileService {
        ProfileServiceImpl(
            networkClient: networkClient,
            storage: profileStorage
        )
    }

    var orderService: OrderServiceProtocol {
        OrderService(
            networkClient: networkClient,
            orderStorage: orderStorage
        )
    }

    var payService: PayServiceProtocol {
        PayService(
            networkClient: networkClient
        )
    }
}
