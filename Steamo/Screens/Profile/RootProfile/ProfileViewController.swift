//
//  ProfileViewController.swift
//  Steamo
//
//  Created by Max Kraev on 24.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import SnapKit
import SVProgressHUD
import UIKit

class ProfileViewController: UIViewController {
    // MARK: - Properties

    /// Вьюмодель экрана
    fileprivate let viewModel: ProfileViewModel
    /// Роутер экрана
    fileprivate let router: ProfileRouterProtocol
    /// Лоадер
    private let shimmeringView = ProfileShimmeringView()

    private var refreshControl = UIRefreshControl()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delaysContentTouches = false
        tableView.alwaysBounceVertical = false
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(class: AvatarTableViewCell.self)
        tableView.register(class: OwnedGamesTableViewCell.self)
        tableView.register(class: FriendTableViewCell.self)
        tableView.register(class: DefaultTableViewCell.self)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return tableView
    }()

    /// Стэквью для показа кнопки логина и логотипа
    private lazy var loginStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logoImageView, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillProportionally

        return stackView
    }()

    /// Логотип стима
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "steamlogo")
        if #available(iOS 11.0, *) {
            imageView.tintColor = UIColor(named: "Text")
        } else {
            imageView.tintColor = .text
        }
        return imageView
    }()

    /// Кнопка авторизации
    private lazy var loginButton: SteamoButton = {
        let button = SteamoButton()
        if #available(iOS 11.0, *) {
            button.backgroundColor = UIColor(named: "Accent")
            button.titleLabel?.textColor = UIColor(named: "Background")
        } else {
            button.backgroundColor = .accent
            button.titleLabel?.textColor = .background
        }
        button.setTitle("SIGN IN", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        button.addTarget(nil, action: #selector(loginButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: ProfileViewModel,
         router: ProfileRouterProtocol) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
        addObservers()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addConstraints()
        toggleUI()
        loadData()
    }

    // MARK: - Methods

    private func addConstraints() {
        title = viewModel.screenTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(loginStackView)
        loginStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        logoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(200)
        }

        loginButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }

        addShimmeringViewIfNeeded()
    }

    private func addShimmeringViewIfNeeded() {
        if viewModel.isUserAuthorized {
            view.addSubview(shimmeringView)
            shimmeringView.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            }
        }
    }

    private func loadData() {
        if viewModel.isUserAuthorized {
            viewModel.loadProfile { [weak self] _ in
                self?.toggleUI()
                self?.shimmeringView.removeFromSuperview()
                self?.tableView.reloadData()
            }
        }
    }

    private func afterLoginRoutine() {
        loginStackView.isHidden = true
        toggleBarButton()
        addShimmeringViewIfNeeded()
        loadData()
    }
    
    // MARK: NotificationCenter
    
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: .DidLogout, object: nil, queue: .main) { _ in
            self.navigationController?.popToRootViewController(animated: false)
            self.viewModel.erase()
            self.toggleUI()
        }
        
        NotificationCenter.default.addObserver(forName: .WillEraseAllData, object: nil, queue: .main) { _ in
            self.navigationController?.popToRootViewController(animated: false)
        }
    }

    // MARK: Toggle UI

    private func toggleUI() {
        toggleBarButton()
        showTableView(viewModel.isUserAuthorized)
        showLoginButton(viewModel.isUserAuthorized)
    }

    private func toggleBarButton() {
        if viewModel.isUserAuthorized {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "dota2"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(routeToDota2Stats))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }

    private func showTableView(_ isUserAuthorized: Bool) {
        tableView.isHidden = !isUserAuthorized
    }

    private func showLoginButton(_ isUserAuthorized: Bool) {
        loginStackView.isHidden = isUserAuthorized
    }

    // MARK: Actions

    @objc private func loginButtonDidTap() {
        router.routeToLogin(from: self) { [weak self] steamUser in
            steamUser.save()
            self?.afterLoginRoutine()
        }
    }

    @objc private func refresh() {
        viewModel.loadProfile { [weak self] _ in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    @objc private func routeToDota2Stats() {
        router.routeToDota2Stats(from: self, steamId: viewModel.currentSteamId ?? "")
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionViewModel = viewModel.sectionViewModels[indexPath.section]

        switch sectionViewModel.type {
        case .friends:
            if let friendsSectionViewModel = sectionViewModel as? FriendsSectionViewModel {
                let steamId = friendsSectionViewModel.profiles.response.players[indexPath.row].steamId
                router.routeToFriendProfile(from: self, steamId: steamId)
            }
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return viewModel.sectionViewModels[safe: section]?.sectionTitle ?? ""
    }

    func numberOfSections(in _: UITableView) -> Int {
        return viewModel.sectionViewModels.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sectionViewModels[safe: section]?.rowCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionViewModel = viewModel.sectionViewModels[safe: indexPath.section] else {
            let cell = UITableViewCell(frame: .zero)
            cell.backgroundColor = .clear
            return cell
        }

        switch sectionViewModel.type {
        case .avatar:
            if let cell: AvatarTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.configure(with: sectionViewModel, index: indexPath.row)
                return cell
            }
        case .ownedGames:
            if let cell: OwnedGamesTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.configure(with: sectionViewModel)
                cell.delegate = self
                return cell
            }
        case .friends:
            if let cell: FriendTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.configure(with: sectionViewModel, index: indexPath.row)
                return cell
            }
        case .noVisibleGames:
            if let cell: DefaultTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.textLabel?.text = "No visible games"
                return cell
            }
        case .noVisibleFriends:
            if let cell: DefaultTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.textLabel?.text = "No visible friends"
                return cell
            }
        }
        assertionFailure("New cell")
        return UITableViewCell()
    }
}

// MARK: - OwnedGamesCollectionViewCellDelegate

extension ProfileViewController: OwnedGamesCollectionViewCellDelegate {
    func cellDidTap(_ cell: UICollectionViewCell, with game: Game?) {
        guard let game = game, let steamId = viewModel.currentSteamId else { return }
        router.routeToGameStats(from: self, steamId: steamId, gameId: game.appId, gameName: game.name)
    }
}
