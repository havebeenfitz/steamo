//
//  CollectionCellContainer.swift
//  Steamo
//
//  Created by Max Kraev on 26.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class CollectionCellContainer<View: ReusableView>: UICollectionViewCell {
    public private(set) lazy var containedView: View = View(frame: .zero)
    
    override var isHighlighted: Bool {
        didSet {
            if let selectableView = containedView as? SelectableView {
                selectableView.setSelected(isSelected: isHighlighted, animated: true)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(containedView)
        containedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containedView.reuse()
    }
}
