//
//  SessionsViewController.swift
//  Steamo
//
//  Created by Max Kraev on 26.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit
import SnapKit

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
        
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        
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
        viewModel.loadRecentlyPlayedGames { [weak self] result in
            self?.tableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
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
