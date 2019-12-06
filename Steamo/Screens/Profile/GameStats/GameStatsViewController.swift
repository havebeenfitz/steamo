//
//  GameStatsViewController.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit
import SVProgressHUD

class GameStatsViewController: UIViewController {
    
    //MARK:- Properties
    
    private let viewModel: GameStatsViewModel
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.alwaysBounceVertical = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 11.0, *) {
            tableView.backgroundColor = UIColor(named: "Background")
            refreshControl.tintColor = UIColor(named: "Accent")
        } else {
            tableView.backgroundColor = .background
            refreshControl.tintColor = .accent
        }

        tableView.register(class: PlayerStatTableViewCell.self)
        tableView.register(class: PlayerAchievementsTableViewCell.self)
        tableView.register(class: StatsErrorTableViewCell.self)
        tableView.register(class: DefaultTableViewCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self

        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return tableView
    }()
    
    //MARK: Lifecycle
    
    init(viewModel: GameStatsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupAppearence()
        addConstraints()
        loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Setup
    
    private func setupAppearence() {
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor(named: "Background")
        } else {
            view.backgroundColor = .background
        }
        title = viewModel.screenTitle()
    }
    
    private func addConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK:- Actions
    
    private func loadData() {
        SVProgressHUD.show(withStatus: "Fetching stats")
        viewModel.load(force: false) { [weak self] _ in
            SVProgressHUD.dismiss()
            self?.reloadTableViewOnMain()
        }
    }
    
    private func reloadTableViewOnMain() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func refresh() {
        
    }
}

//MARK:- UITableView Delegate & Datasource

extension GameStatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SectionHeaderView()
        let title = viewModel.sectionViewModels[safe: section]?.sectionTitle ?? ""
        view.configure(with: title)
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionViewModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionViewModels[safe: section]?.rowCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionViewModel = viewModel.sectionViewModels[safe: indexPath.section] else {
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
        }
        
        switch sectionViewModel.type {
        case .playerStats:
            if let cell: PlayerStatTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.configure(with: sectionViewModel, index: indexPath.row)
                return cell
            }
        case .playerAchievements:
            if let cell: PlayerAchievementsTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.configure(with: sectionViewModel, index: indexPath.row)
                return cell
            }
        case .noPlayerStats:
            if let cell: DefaultTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.textLabel?.text = "No visible player stats"
                return cell
            }
        case .noPlayerAchievements:
            if let cell: DefaultTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.textLabel?.text = "No visible player achievements"
                return cell
            }
        case .nothing:
            if let cell: StatsErrorTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.configure(with: .noCommonStats)
                return cell
            }
        }
        
        assertionFailure("New cell")
        return UITableViewCell()
    }
}
