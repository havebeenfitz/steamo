//
//  SectionHeaderView.swift
//  Steamo
//
//  Created by Max Kraev on 27.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        if #available(iOS 11.0, *) {
            label.textColor = UIColor(named: "Text")
        } else {
            label.textColor = .text
        }
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
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
