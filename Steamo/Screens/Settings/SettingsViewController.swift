//
//  SettingsViewController.swift
//  Steamo
//
//  Created by Max Kraev on 27.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    fileprivate let viewModel: SettingsViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.delaysContentTouches = false
        tableView.alwaysBounceVertical = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 11.0, *) {
            tableView.backgroundColor = UIColor(named: "Background")
        } else {
            tableView.backgroundColor = .background
        }
        tableView.register(class: UITableViewCell.self)

        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()
    
    private lazy var logoutButton: SteamoButton = {
        let button = SteamoButton()
        button.setTitle("Log out", for: .normal)
        button.backgroundColor = .accent
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return button
    }()

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor(named: "Background")
        } else {
            view.backgroundColor = .background
        }

        title = "Settings"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: Actions
    
    @objc private func logout() {
        viewModel.logout()
    }
    
    @objc private func eraseAllData() {
        let ac = UIAlertController(title: "Are you sure?", message: "This cannot be undone", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.eraseAll()
        }))
        ac.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            ac.dismiss(animated: true, completion: nil)
        }))
        
        present(ac, animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SectionHeaderView()
        let title = section == 0 ? "Profile" : "Data"
        view.configure(with: title)
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UITableViewCell = tableView.dequeue(indexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            let button = SteamoButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            button.setImage(UIImage(named: "logout"), for: .normal)
            button.addTarget(self, action: #selector(logout), for: .touchUpInside)
            button.tintColor = .systemBlue
            cell.accessoryView = button
            cell.textLabel?.text = "Logout"
            return cell
        case 1:
            let button = SteamoButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            button.tintColor = .systemRed
            button.setImage(UIImage(named: "wipe"), for: .normal)
            button.addTarget(self, action: #selector(eraseAllData), for: .touchUpInside)
            cell.accessoryView = button
            cell.textLabel?.text = "Erase all stored data"
            return cell
        default:
            break
        }
        
        assertionFailure("New cell")
        return UITableViewCell()
    }
}
