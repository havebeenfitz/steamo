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
        viewModel.loadRecentlyPlayedGames { [weak self] _ in
            self?.tableView.reloadData()
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func refresh() {
        refreshControl.endRefreshing()
    }

    private func setup() {
        title = "Sessions"
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
}

extension SessionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.games?.response?.totalCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let game = viewModel.games?.response?.games?[indexPath.row],
            let cell: TableCellContainer<GameView> = tableView.dequeue(indexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.containedView.configure(with: game)

        return cell
    }
}
