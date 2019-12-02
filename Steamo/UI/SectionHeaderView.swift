//
//  SectionHeaderView.swift
//  Steamo
//
//  Created by Max Kraev on 27.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {
    private lazy var titleLabel: SteamoLabel = {
        let label = SteamoLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String) {
        titleLabel.text = title
    }

    private func setup() {
        if #available(iOS 11.0, *) {
            backgroundColor = UIColor(named: "Background")
        } else {
            backgroundColor = .background
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(10)
        }
    }
}
