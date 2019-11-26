//
//  ProfileTableViewCell.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

class AvatarTableViewCell: UITableViewCell {
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        if #available(iOS 11.0, *) {
            label.textColor = UIColor(named: "Text")
        } else {
            label.textColor = .text
        }
        
        label.font = UIFont.systemFont(ofSize: 25)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var onlineStatusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var onlineStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        if #available(iOS 11.0, *) {
            label.textColor = UIColor(named: "Text")
        } else {
            label.textColor = .text
        }
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: ProfileCellViewModelRepresentable?) {
        guard let viewModel = viewModel as? AvatarCellViewModel, let url = URL(string: viewModel.avatarURLString) else {
            return
        }
        avatarImageView.kf.setImage(with: url)
        nameLabel.text = viewModel.name
        
        switch viewModel.status {
            
        case .offline:
            onlineStatusView.backgroundColor = .lightGray
            onlineStatusLabel.text = "Offline"
        case .online:
            onlineStatusView.backgroundColor = .systemGreen
            onlineStatusLabel.text = "Online"
        case .busy:
            onlineStatusView.backgroundColor = .systemRed
            onlineStatusLabel.text = "Busy"
        case .away:
            onlineStatusView.backgroundColor = .systemYellow
            onlineStatusLabel.text = "Away"
        case .snooze:
            onlineStatusView.backgroundColor = .systemTeal
            onlineStatusLabel.text = "Snooze"
        case .trade:
            onlineStatusView.backgroundColor = .systemBlue
            onlineStatusLabel.text = "Looking for trade"
        case .lookingToPlay:
            onlineStatusView.backgroundColor = .systemPink
            onlineStatusLabel.text = "Looking to play"
        }
    }
    
    private func setup() {
        selectionStyle = .none
        
        if #available(iOS 11.0, *) {
            contentView.backgroundColor = UIColor(named: "Background")
        } else {
            contentView.backgroundColor = .background
        }
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(20).priority(.required)
            make.height.width.equalTo(100).priority(.init(999))
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(20)
            make.top.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(onlineStatusView)
        onlineStatusView.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(25)
            make.left.equalTo(nameLabel.snp.right).offset(20).priority(.low)
            make.height.width.equalTo(25)
        }
        
        contentView.addSubview(onlineStatusLabel)
        onlineStatusLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
        }
    }
    
    
}
