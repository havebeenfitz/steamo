//
//  GameCollectionViewCell.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    private var gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gameImageView.image = nil
    }
}
