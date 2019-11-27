//
//  CollectionCellContainer.swift
//  Steamo
//
//  Created by Max Kraev on 26.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class CollectionCellContainer<View: UIView>: UICollectionViewCell {
    public private(set) lazy var containedView: View = View(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(containedView)
        containedView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}
