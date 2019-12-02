//
//  PlayerStatTableViewCell.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class PlayerStatTableViewCell: UITableViewCell {
    
    private let statImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stats")
        if #available(iOS 11.0, *) {
            imageView.tintColor = UIColor(named: "Accent")
        } else {
            imageView.tintColor = .accent
        }
        return imageView
    }()
    
    private let statTitleLabel: SteamoLabel = {
        let label = SteamoLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let statValueLabel: SteamoLabel = {
        let label = SteamoLabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: StatsSectionViewModelRepresentable, index: Int) {
        guard let viewModel = viewModel as? PlayerStatsSectionViewModel else {
            return
        }
        
        let statName = viewModel.statDisplayName(at: index)
        let statValue = Int(viewModel.stats.playerStats?.stats?[safe: index]?.value ?? 0)
        
        statTitleLabel.text = statName
        statValueLabel.text = "\(statValue)"
    }
    
    private func setup() {
        if #available(iOS 11.0, *) {
            contentView.backgroundColor = UIColor(named: "Background")
        } else {
            contentView.backgroundColor = .background
        }
        
        contentView.addSubview(statImageView)
        statImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        contentView.addSubview(statTitleLabel)
        statTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.left.equalTo(statImageView.snp.right).offset(20)
        }
        
        contentView.addSubview(statValueLabel)
        statValueLabel.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview().inset(20)
            make.left.equalTo(statTitleLabel.snp.right).offset(20)
        }
    }
}
