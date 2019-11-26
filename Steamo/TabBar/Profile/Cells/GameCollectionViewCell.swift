//
//  GameCollectionViewCell.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    private let gameImageView: UIImageView = {
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
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
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
    }
    
    private func setup() {
        contentView.layer.cornerRadius = 10
        if #available(iOS 11.0, *) {
            contentView.backgroundColor = UIColor(named: "Background")
        } else {
            contentView.backgroundColor = .background
        }
        
        contentView.addSubview(gameImageView)
        gameImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(20)
            make.height.equalTo(110)
            let screenInset: CGFloat = 40.0
            make.width.equalTo(UIScreen.main.bounds.width - screenInset)
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
