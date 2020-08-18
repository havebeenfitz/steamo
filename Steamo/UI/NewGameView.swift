//
//  NewGameView.swift
//  Steamo
//
//  Created by Alexander on 8/18/20.
//  Copyright © 2020 Max Kraev. All rights reserved.
//

import UIKit

protocol SelectableView: UIView {
    func setSelected(isSelected: Bool, animated: Bool)
}

class NewGameView: UIView, ReusableView, SelectableView {
    private lazy var gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

     let overlayView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
    }()

     let visualEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()

     private lazy var gameTitleLabel: SteamoLabel = {
        let label = SteamoLabel()
        label.textAlignment = .left
        label.textColor = UIColor.secondaryLabel
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2

         return label
    }()

     private lazy var playtimeTitleLabel: SteamoLabel = {
        let label = SteamoLabel()
        label.text = "Playtime"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1

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
        guard let game = game, let url = game.calculatedImageLogoUrl else { return }
        gameImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        gameTitleLabel.text = game.name
        playtimeValueLabel.text = "Total: \(game.playtimeForever.steamFormatted())"
        if let recentPlaytime = game.playtime2Weeks.value {
            recentPlaytimeValueLabel.text = "2 weeks: \(recentPlaytime.steamFormatted())"
        }
    }

     override func layoutIfNeeded() {
        super.layoutIfNeeded()
        visualEffect.effect = UIBlurEffect(style: .light)
    }

     private func setup() {
        addSubview(gameImageView)
        gameImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

         overlayView.addSubview(visualEffect)
        visualEffect.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

         addSubview(overlayView)
        overlayView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(gameImageView.snp.height).multipliedBy(0.6)
        }

         overlayView.addSubview(playtimeTitleLabel)
        playtimeTitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
        }

         overlayView.addSubview(playtimeValueLabel)
        playtimeValueLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.top.equalTo(playtimeTitleLabel.snp.bottom).offset(10)
        }

         overlayView.addSubview(recentPlaytimeValueLabel)
        recentPlaytimeValueLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.top.equalTo(playtimeValueLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(8)
        }

         overlayView.addSubview(gameTitleLabel)
        gameTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(8)
        }
    }

     func reuse() {
        playtimeValueLabel.text = nil
        recentPlaytimeValueLabel.text = nil
    }

    func setSelected(isSelected: Bool, animated: Bool) {
        let animation = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.4) {
            self.transform = isSelected ? .init(scaleX: 0.9, y: 0.9) : .identity
        }
        animation.startAnimation()
    }
}
