final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let usersStorage: UsersStorage
    private let profileStorage: ProfileStorage
    private let orderStorage: OrderStorage
    private let userInfoStorage: UserInfoStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        usersStorage: UsersStorage,
        profileStofare: ProfileStorage,
        orderStorage: OrderStorage,
        userInfoStorage: UserInfoStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.usersStorage = usersStorage
        self.profileStorage = profileStofare
        self.orderStorage = orderStorage
        self.userInfoStorage = userInfoStorage
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

    var orderService: OrderService {
        OrderServiceImpl(
            networkClient: networkClient,
            orderStorage: orderStorage
        )
    }

    var payService: PayService {
        PayServiceImpl(
            networkClient: networkClient
        )
    }

    var userInfoService: UserInfoServiceImpl {
        UserInfoServiceImpl(
            networkClient: networkClient,
            storage: userInfoStorage
        )
    }
}
