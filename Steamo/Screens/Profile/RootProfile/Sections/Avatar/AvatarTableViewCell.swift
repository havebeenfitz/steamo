//
//  ProfileTableViewCell.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

class AvatarTableViewCell: UITableViewCell {
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: SteamoLabel = {
        let label = SteamoLabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)

        return label
    }()

    private lazy var onlineStatusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7.5
        return view
    }()

    private lazy var onlineStatusLabel: SteamoLabel = {
        let label = SteamoLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: ProfileSectionViewModelRepresentable?, index: Int) {
        guard let viewModel = viewModel as? AvatarSectionViewModel else {
            return
        }
        let player = viewModel.profiles.response.players[index]
        let url = URL(string: player.avatarFull)
        avatarImageView.kf.setImage(with: url)
        nameLabel.text = player.personaName

        switch player.onlineStatus {
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
            make.top.right.equalToSuperview().inset(27)
            make.left.equalTo(nameLabel.snp.right).offset(20)
            make.height.width.equalTo(15)
        }

        contentView.addSubview(onlineStatusLabel)
        onlineStatusLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
        }
    }
}
