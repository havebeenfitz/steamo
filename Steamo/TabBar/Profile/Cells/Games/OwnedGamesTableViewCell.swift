//
//  OwnedGamesTableViewCell.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class OwnedGamesTableViewCell: UITableViewCell {
    
    private var viewModel: OwnedGamesCellViewModel?
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        if #available(iOS 11.0, *) {
            collectionView.backgroundColor = UIColor(named: "Background")
        } else {
            collectionView.backgroundColor = .background
        }
        
        collectionView.register(class: CollectionCellContainer<GameView>.self)
        
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: ProfileCellViewModelRepresentable) {
        guard let viewModel = viewModel as? OwnedGamesCellViewModel else { return }
        self.viewModel = viewModel
        collectionView.reloadData()
    }
    
    private func setup() {
        selectionStyle = .none
        
        if #available(iOS 11.0, *) {
            contentView.backgroundColor = UIColor(named: "Background")
        } else {
            contentView.backgroundColor = .background
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(200).priority(.init(999))
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
}

extension OwnedGamesTableViewCell: UICollectionViewDelegate {}

extension OwnedGamesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.games.response.games.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel,
              let cell: CollectionCellContainer<GameView> = collectionView.dequeue(indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.containedView.configure(with: viewModel.games.response.games[indexPath.item])
        
        return cell
    }
}
