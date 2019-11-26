//
//  GameCollectionViewCell.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    private lazy var gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private lazy var gameTitleLabel: UILabel = {
        let label = UILabel()
        if #available(iOS 11.0, *) {
            label.textColor = UIColor(named: "Text")
        } else {
            label.textColor = .text
        }
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 25)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var playTimeLabel: UILabel = {
        let label = UILabel()
        if #available(iOS 11.0, *) {
            label.textColor = UIColor(named: "Text")
        } else {
            label.textColor = .text
        }
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with game: Game) {
        guard let url = game.calculatedImageIconUrl else { return }
        gameImageView.kf.setImage(with: url)
        gameTitleLabel.text = game.name
        playTimeLabel.text = "Playtime:\n\(game.playtimeForever.steamFormatted())"
    }
    
    private func setup() {
        contentView.layer.cornerRadius = 10
        if #available(iOS 11.0, *) {
            contentView.backgroundColor = UIColor(named: "Background")
        } else {
            contentView.backgroundColor = .background
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(gameImageView)
        gameImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(20)
            make.height.equalTo(64)
            make.width.equalTo(186)
        }
        
        contentView.addSubview(playTimeLabel)
        playTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(gameImageView.snp.right).offset(20)
            make.centerY.equalTo(gameImageView.snp.centerY)
        }
        
        contentView.addSubview(gameTitleLabel)
        gameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(gameImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gameImageView.image = nil
    }
}
