//
//  Dota2StatsViewControllert.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class Dota2StatsViewController: UIViewController {
    
    //MARK:- Properties
    
    private let viewModel: Dota2StatsViewModel
    
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
        
        tableView.register(class: TotalWinsTableViewCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self

        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return tableView
    }()
    
    //MARK:- Lifecycle
    
    init(viewModel: Dota2StatsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
    }
    
    //MARK:- Methods
    
    private func setup() {
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor(named: "Background")
        } else {
            view.backgroundColor = .background
        }
        
        title = "Dota2 Stats"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadData() {
        viewModel.fetch { [weak self] result in
            self?.tableView.reloadData()
        }
    }
    
    @objc private func refresh() {
        
    }
}

extension Dota2StatsViewController: UITableViewDelegate, UITableViewDataSource {
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
        return viewModel.sectionViewModels[safe: section]?.rowCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionViewModel = viewModel.sectionViewModels[safe: indexPath.section] else {
            return UITableViewCell()
        }
        
        switch sectionViewModel.type {
        case .totalWins:
            if let cell: TotalWinsTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.configure(with: sectionViewModel)
                return cell
            }
        case .gameSummary:
            return UITableViewCell()
        
        case .winsByDate:
            return UITableViewCell()
        }
        
        assertionFailure("NewCell")
        return UITableViewCell()
    }
    
    
}
