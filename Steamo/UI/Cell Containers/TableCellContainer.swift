//
//  TableCellContainer.swift
//  Steamo
//
//  Created by Max Kraev on 26.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class TableCellContainer<View: ReusableView>: UITableViewCell {
    public private(set) lazy var containedView: View = View(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        selectionStyle = .none

        contentView.addSubview(containedView)
        containedView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containedView.reuse()
    }
}
