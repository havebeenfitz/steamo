//
//  Dota2StatsViewControllert.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit
import ProgressHUD

class Dota2StatsViewController: UIViewController {
    
    //MARK:- Properties
    
    private let viewModel: Dota2StatsViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.alwaysBounceVertical = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 11.0, *) {
            tableView.backgroundColor = UIColor(named: "Background")
        } else {
            tableView.backgroundColor = .background
        }
        
        tableView.register(class: WinRateTableViewCell.self)
        tableView.register(class: MatchesByDateTableViewCell.self)
        tableView.register(class: StatsErrorTableViewCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()
    
    //MARK:- Lifecycle
    
    init(viewModel: Dota2StatsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.cancelRequest()
        ProgressHUD.dismiss()
    }
    
    //MARK:- Methods
    
    private func setup() {
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor(named: "Background")
        } else {
            view.backgroundColor = .background
        }
        
        title = "Dota2 Stats"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadData))
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func loadData() {
        ProgressHUD.show("Fetching match history", icon: .message, interaction: false)
        viewModel.fetch(progress: { progress in
            ProgressHUD.showProgress("Fetching new matches\nThis might take a while", CGFloat(progress))
        }, completion: { [weak self] _ in
            self?.reloadTableViewOnMain()
            ProgressHUD.dismiss()
        })
    }
    
    private func reloadTableViewOnMain() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.tableView.reloadData()
        }
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
        case .winRate:
            if let cell: WinRateTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.configure(with: sectionViewModel)
                return cell
            }
        case .matchesByDate:
            if let cell: MatchesByDateTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.configure(with: sectionViewModel)
                return cell
            }
        case .error:
            if let cell: StatsErrorTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.configure(with: .noDota2Stats)
                return cell
            }
        }
        
        assertionFailure("NewCell")
        return UITableViewCell()
    }
}
