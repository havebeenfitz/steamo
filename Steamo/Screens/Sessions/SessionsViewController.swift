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

    private lazy var tableView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let tableView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        tableView.backgroundColor = .systemBackground
        tableView.alwaysBounceVertical = false

        tableView.register(class: CollectionCellContainer<NewGameView>.self)

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
        viewModel.load() { [weak self] _ in
            self?.tableView.reloadData()
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func refresh() {
        viewModel.load() { [weak self] _ in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true

    }

    private func setup() {
        title = "My sessions"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: .DidLogin, object: nil, queue: .main) { _ in
            self.viewModel.load() { [weak self] _ in
                self?.tableView.reloadData()
            }
        }
        
        NotificationCenter.default.addObserver(forName: .WillLogout, object: nil, queue: .main) { _ in
            self.viewModel.сlear()
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(forName: .DidEraseAllData, object: nil, queue: .main) { _ in
            self.viewModel.сlear()
            self.tableView.reloadData()
        }
    }
}

extension SessionsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sectionViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sectionViewModels[safe: section]?.rowCount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionViewModel = viewModel.sectionViewModels[safe: indexPath.section] else {
            let cell = UICollectionViewCell()
            cell.backgroundColor = .clear
            return cell
        }
        
        switch sectionViewModel.type {
        case .inTwoWeeks, .older:
            if let cell: CollectionCellContainer<NewGameView> = collectionView.dequeue(indexPath: indexPath) {
                let game = sectionViewModel.games[indexPath.row]
                cell.containedView.configure(with: game)
                return cell
            }
        case .nothingInTwoWeeks, .nothingAtAll:
            break
        }
        
        assertionFailure("New cell")
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 16 * 3) / 2, height: 230)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
