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
        let flowLayout = LeftLayout()
        flowLayout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear

        collectionView.showsHorizontalScrollIndicator = false

        collectionView.register(class: CollectionCellContainer<NewGameView>.self)

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

        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(230).priority(.init(999))
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

extension OwnedGamesTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        viewModel?.games.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel,
            let cell: CollectionCellContainer<NewGameView> = collectionView.dequeue(indexPath: indexPath) else {
            return UICollectionViewCell()
        }

        cell.containedView.configure(with: viewModel.games[safe: indexPath.item])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 16 * 4) / 2, height: 230)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
