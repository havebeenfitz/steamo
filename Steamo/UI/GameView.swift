//
//  GameCollectionViewCell.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

protocol ReusableView: UIView {
    /// Подготовить к переиспользованию
    func reuse()
}

class GameView: UIView, ReusableView {
    private lazy var gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private lazy var gameTitleLabel: SteamoLabel = {
        let label = SteamoLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 25)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0

        return label
    }()
    
    private lazy var playtimeTitleLabel: SteamoLabel = {
        let label = SteamoLabel()
        label.text = "Playtime"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0

        return label
    }()

    private lazy var playtimeValueLabel: SteamoLabel = {
        let label = SteamoLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1

        return label
    }()
    
    private lazy var recentPlaytimeValueLabel: SteamoLabel = {
        let label = SteamoLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with game: Game?) {
        guard let game = game, let url = game.calculatedImageIconUrl else { return }
        gameImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        gameTitleLabel.text = game.name
        playtimeValueLabel.text = "Total: \(game.playtimeForever.steamFormatted())"
        if let recentPlaytime = game.playtime2Weeks.value {
            recentPlaytimeValueLabel.text = "2 weeks: \(recentPlaytime.steamFormatted())"
        }
    }

    private func setup() {
        snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(160).priority(.init(999))
        }

        addSubview(gameImageView)
        gameImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(20)
            make.height.equalTo(64)
            make.width.equalTo(186)
        }
        
        addSubview(playtimeTitleLabel)
        playtimeTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(gameImageView.snp.right).offset(20)
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(gameImageView.snp.top)
        }

        addSubview(playtimeValueLabel)
        playtimeValueLabel.snp.makeConstraints { make in
            make.left.equalTo(gameImageView.snp.right).offset(20)
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(playtimeTitleLabel.snp.bottom).offset(10)
        }
        
        addSubview(recentPlaytimeValueLabel)
        recentPlaytimeValueLabel.snp.makeConstraints { make in
            make.left.equalTo(gameImageView.snp.right).offset(20)
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(playtimeValueLabel.snp.bottom)
        }

        addSubview(gameTitleLabel)
        gameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(gameImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    func reuse() {
        playtimeValueLabel.text = nil
        recentPlaytimeValueLabel.text = nil
    }
}
