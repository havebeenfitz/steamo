//
//  SettingsViewController.swift
//  Steamo
//
//  Created by Max Kraev on 27.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    enum Section {
        case profile(rows: [Row])
        case data(rows: [Row])

        var title: String {
            switch self {
            case .profile:
                return "Profile"
            case .data:
                return "Date"
            }
        }

        var rows: [Row] {
            switch self {
            case let .profile(rows):
                return rows
            case let .data(rows):
                return rows
            }
        }
    }

    enum Row {
        case logout
        case eraseData
        case erasePartData
    }

    var sections: [Section] = [
        .profile(rows: [
            .logout
        ]),
        .data(rows: [
            .eraseData
        ]),
    ]

    fileprivate let viewModel: SettingsViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.delaysContentTouches = false
        tableView.alwaysBounceVertical = false
        tableView.register(class: DefaultTableViewCell.self)

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
        self.navigationController?.navigationBar.prefersLargeTitles = true
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

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = sections[indexPath.section].rows[indexPath.row]
        switch item {
        case .erasePartData:
            self.eraseAllData()
        case .logout:
            self.logout()
        case .eraseData:
            self.eraseAllData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DefaultTableViewCell = tableView.dequeue(indexPath: indexPath) else {
            return UITableViewCell()
        }

        let item = sections[indexPath.section].rows[indexPath.row]
        switch item {
        case .erasePartData:
            cell.imageView?.tintColor = UIColor.red
            cell.imageView?.image = UIImage(systemName: "clear")
            cell.textLabel?.text = "Erase PART stored data"
            return cell
        case .logout:
            cell.imageView?.image = UIImage(systemName: "escape")
            cell.textLabel?.text = "Logout"
            return cell
        case .eraseData:
            cell.imageView?.tintColor = UIColor.red
            cell.imageView?.image = UIImage(systemName: "clear")
            cell.textLabel?.text = "Erase all stored data"
            return cell
        }
    }
}
