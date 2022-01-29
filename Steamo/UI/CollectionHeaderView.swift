//
//  CollectionHeaderView.swift
//  Steamo
//
//  Created by Alexander on 8/18/20.
//  Copyright © 2020 Max Kraev. All rights reserved.
//

import UIKit

 class CollectionHeaderView: UICollectionReusableView {
    let label = UILabel()

     override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

     required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     func setup() {
        self.addSubview(self.label)
        self.label.textColor = UIColor.secondaryLabel
        self.label.font = UIFont.systemFont(ofSize: 13)
        self.label.snp.makeConstraints { (maker) in
            maker.bottom.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 16))
        }
    }
}
