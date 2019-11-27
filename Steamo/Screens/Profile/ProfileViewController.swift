//
//  ProfileViewController.swift
//  Steamo
//
//  Created by Max Kraev on 24.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

class ProfileViewController: UIViewController {
    
    /// Вьюмодель экрана
    fileprivate let viewModel: ProfileViewModel
    
    fileprivate let router: ProfileRouter
    
    private var refreshControl = UIRefreshControl()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.alwaysBounceVertical = false
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 11.0, *) {
            tableView.backgroundColor = UIColor(named: "Background")
            refreshControl.tintColor = UIColor(named: "Accent")
        } else {
            tableView.backgroundColor = .background
            refreshControl.tintColor = .accent
        }
        
        tableView.register(class: AvatarTableViewCell.self)
        tableView.register(class: OwnedGamesTableViewCell.self)
        tableView.register(class: FriendTableViewCell.self)
        
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
        button.setTitle("Sing in", for: .normal)
        button.addTarget(nil, action: #selector(loginButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: ProfileViewModel,
         router: ProfileRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        toggleLogoutButton()
        loadData()
    }
    
    @objc private func loginButtonDidTap() {
        let loginVC = LoginViewController(nibName: nil, bundle: nil)
        let loginNavigationVC = loginVC.wrapInNavigation()
        loginVC.completion = { [weak self] steamUser in
            self?.viewModel.steamId = steamUser.steamID64
            self?.loginStackView.isHidden = true
            self?.toggleLogoutButton()
            self?.loadData()
        }
        present(loginNavigationVC, animated: true)
    }
    
    private func loadData() {
        if viewModel.isUserAuthorized {
            SVProgressHUD.show()
            viewModel.loadProfile { [weak self] _ in
                self?.showLoginButton(isUserAuthorized: true)
                self?.showTableView(isUserAuthorized: true)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    private func setup() {
        title = viewModel.screenTitle
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor(named: "Background")
        } else {
            view.backgroundColor = .background
        }
        
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
    }
    
    @objc private func refresh() {
        viewModel.loadProfile { [weak self] _ in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    private func toggleLogoutButton() {
        if viewModel.isUserAuthorized {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "stats"),
                                                                style: .plain,
                                                                target: self,
                                                                action: nil)
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        showLoginButton(isUserAuthorized: viewModel.isUserAuthorized)
        showTableView(isUserAuthorized: viewModel.isUserAuthorized)
    }
    
    private func showTableView(isUserAuthorized: Bool) {
        tableView.isHidden = !isUserAuthorized
        if isUserAuthorized {
            tableView.reloadData()
        }
    }

    private func showLoginButton(isUserAuthorized: Bool) {
        loginStackView.isHidden = isUserAuthorized
    }
}

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

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SectionHeaderView()
        let title = viewModel.sectionViewModels[safe: section]?.sectionTitle ?? ""
        view.configure(with: title)
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionViewModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sectionViewModels[safe: section]?.rowCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionViewModel = viewModel.sectionViewModels[safe: indexPath.section] else {
            return UITableViewCell()
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
                return cell
            }
        case .friends:
            if let cell: FriendTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.configure(with: sectionViewModel, index: indexPath.row)
                return cell
            }
        }
        assertionFailure("New cell")
        return UITableViewCell()
    }
    
    
}
