//
//  OwnedGamesTableViewCell.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

protocol OwnedGamesCollectionViewCellDelegate: class {
    func cellDidTap(_ cell: UICollectionViewCell, with game: Game?)
}

class OwnedGamesTableViewCell: UITableViewCell {
    fileprivate var viewModel: OwnedGamesSectionViewModel?
    
    weak var delegate: OwnedGamesCollectionViewCellDelegate?

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 170)
        flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.isPagingEnabled = true
        collectionView.delaysContentTouches = false
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

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: ProfileSectionViewModelRepresentable) {
        guard let viewModel = viewModel as? OwnedGamesSectionViewModel else { return }
        self.viewModel = viewModel
        collectionView.reloadData()
    }

    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear

        if #available(iOS 11.0, *) {
            contentView.backgroundColor = UIColor(named: "Background")
        } else {
            contentView.backgroundColor = .background
        }

        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(170).priority(.init(999))
            make.edges.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
}

extension OwnedGamesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cell(for: indexPath) else {
            return
        }
        delegate?.cellDidTap(cell, with: viewModel?.games[safe: indexPath.item])
    }
}

extension OwnedGamesTableViewCell: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        viewModel?.games.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel,
            let cell: CollectionCellContainer<GameView> = collectionView.dequeue(indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        cell.containedView.configure(with: viewModel.games[safe: indexPath.item])

        return cell
    }
}
