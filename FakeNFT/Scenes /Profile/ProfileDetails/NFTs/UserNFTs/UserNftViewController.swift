import UIKit

protocol UserNftView: AnyObject, ErrorView, LoadingView {
    func fetchNfts(_ nft: [Nft])
}

final class UserNftViewController: UIViewController {

    internal lazy var activityIndicator = UIActivityIndicatorView()

    private var presenter: UserNftPresenter

    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "sort")
        return button
    }()

    private lazy var nftsTable: UITableView = {
        let tableView = UITableView()
        tableView.register(NftCell.self, forCellReuseIdentifier: NftCell.identifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас ещё нет NFT"
        label.font = .bodyBold
        label.textColor = UIColor(named: "Black")
        return label
    }()

    private var nfts: [Nft] = []

    // MARK: - Init

    init(presenter: UserNftPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupUI()

        setupNavigationBar()
        showEmptyCart()
    }

    private func showEmptyCart() {
        if nfts.count == 0 {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
            setupNavigationBar()
            nftsTable.reloadData()
        }
    }

    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else {
            return

        }
        let rightButton = UIBarButtonItem(image: UIImage(named: "sort"), style: .plain, target: self, action: #selector(didTapSortButton))
        rightButton.tintColor = UIColor(named: "Black")
        navigationBar.topItem?.setRightBarButton(rightButton, animated: false)
    }

    @objc private func didTapSortButton() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "По цене", style: .default, handler: { [weak self] (_) in
            guard self != nil else { return }
            // TODO: реализовать сортировку
        }))

        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default, handler: { [weak self] (_) in
            guard self != nil else { return }
            // TODO: реализовать сортировку
        }))

        alert.addAction(UIAlertAction(title: "По названию", style: .default, handler: { [weak self] (_) in
            guard self != nil else { return }
            // TODO: реализовать сортировку
        }))

        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: { (_) in
        }))

        self.present(alert, animated: true)
    }
}

extension UserNftViewController {
    private func setupUI() {
        [emptyLabel, nftsTable].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            nftsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UserNFTsView

extension UserNftViewController: UserNftView {
    func fetchNfts(_ nft: [Nft]) {
        self.nfts = nft
        nftsTable.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension UserNftViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nfts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NftCell.identifier,
            for: indexPath) as? NftCell else {
            return UITableViewCell()
        }

        let nft = nfts[indexPath.row]
        cell.updateCell(with: nft)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
