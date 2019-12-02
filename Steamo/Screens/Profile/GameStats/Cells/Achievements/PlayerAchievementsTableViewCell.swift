//
//  PlayerAchievementsTableViewCell.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class PlayerAchievementsTableViewCell: UITableViewCell {
    private let achievementLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let achievementTitleLabel: SteamoLabel = {
        let label = SteamoLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let achievementDescriptionLabel: SteamoLabel = {
        let label = SteamoLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
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
        guard let viewModel = viewModel as? PlayerAchievementsSectionViewModel else {
            return
        }
        
        if let url = URL(string: viewModel.achievementLogoPath(at: index)) {
            achievementLogoImageView.kf.setImage(with: url)
        }
        
        achievementTitleLabel.text = viewModel.achievementDisplayName(at: index)
        achievementDescriptionLabel.text = viewModel.achievementDescription(at: index)
    }
    
    private func setup() {
        if #available(iOS 11.0, *) {
            contentView.backgroundColor = UIColor(named: "Background")
        } else {
            contentView.backgroundColor = .background
        }
        
        contentView.addSubview(achievementLogoImageView)
        achievementLogoImageView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview().inset(20)
            make.height.width.equalTo(60).priority(.init(999))
        }
        
        contentView.addSubview(achievementTitleLabel)
        achievementTitleLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(20)
            make.left.equalTo(achievementLogoImageView.snp.right).offset(20)
        }
        
        contentView.addSubview(achievementDescriptionLabel)
        achievementDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(achievementTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(achievementLogoImageView.snp.right).offset(20)
            make.right.equalToSuperview().inset(20)
        }
    }
}

