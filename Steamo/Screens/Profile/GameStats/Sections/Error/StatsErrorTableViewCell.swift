//
//  StatsErrorTableViewCell.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class StatsErrorTableViewCell: UITableViewCell {
    
    enum ErrorStyle {
        case noCommonStats
        case noDota2Stats
    }
    
    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "error")
        if #available(iOS 11.0, *) {
            imageView.tintColor = UIColor(named: "Text")
        } else {
            imageView.tintColor = .text
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let errorLabel: SteamoLabel = {
        let label = SteamoLabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with style: ErrorStyle) {
        switch style {
        case .noCommonStats:
            errorLabel.text = """
                              It seems like user prefer
                              not to share his/her stats
                              
                              Or maybe there is no visible statistics
                              """
        case .noDota2Stats:
            errorLabel.text = """
                              It seems like user either
                              didn't play Dota2 or private
                              """
        }
    }
    
    private func setup() {
        if #available(iOS 11.0, *) {
            contentView.backgroundColor = UIColor(named: "Background")
        } else {
            contentView.backgroundColor = .background
        }
        
        let stackView = UIStackView(arrangedSubviews: [errorImageView, errorLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        errorImageView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
    }
}
