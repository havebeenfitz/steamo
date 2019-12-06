//
//  SessionsViewController.swift
//  Steamo
//
//  Created by Max Kraev on 26.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import SnapKit
import UIKit

class SessionsViewController: UIViewController {
    private let viewModel: SessionsViewModel

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

        tableView.register(class: TableCellContainer<GameView>.self)
        tableView.register(class: UITableViewCell.self)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return tableView
    }()

    init(viewModel: SessionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        viewModel.load(force: false) { [weak self] _ in
            self?.tableView.reloadData()
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func refresh() {
        viewModel.load(force: true) { [weak self] _ in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
    }

    private func setup() {
        title = "My sessions"
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor(named: "Background")
        } else {
            view.backgroundColor = .background
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: .DidLogin, object: nil, queue: .main) { _ in
            self.viewModel.load(force: false) { [weak self] _ in
                self?.tableView.reloadData()
            }
        }
        
        NotificationCenter.default.addObserver(forName: .WillLogout, object: nil, queue: .main) { _ in
            self.viewModel.erase()
            self.tableView.reloadData()
        }
    }
}

extension SessionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
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
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sectionViewModels[safe: section]?.rowCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionViewModel = viewModel.sectionViewModels[safe: indexPath.section] else {
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
        }
        
        switch sectionViewModel.type {
        case .inTwoWeeks, .older:
            if let cell: TableCellContainer<GameView> = tableView.dequeue(indexPath: indexPath) {
                let game = sectionViewModel.games[indexPath.row]
                cell.containedView.configure(with: game)
                return cell
            }
        case .nothing:
            if let cell: UITableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.accessoryType = .detailButton
                cell.textLabel?.text = "No recent sessions to display"
                cell.backgroundColor = .clear
                return cell
            }
        }
        
        assertionFailure("New cell")
        return UITableViewCell()
    }
}
