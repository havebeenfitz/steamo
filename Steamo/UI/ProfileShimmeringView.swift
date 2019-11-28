//
//  ProfileShimmeringView.swift
//  Steamo
//
//  Created by Max Kraev on 28.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit
import SnapKit

class PlaceholderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .lightGray
        layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProfileShimmeringView: UIView {
    
    private let avatarView = PlaceholderView()
    private let nameView = PlaceholderView()
    private let onlineBadgeView = PlaceholderView()
    private let onlineStatusView = PlaceholderView()
    
    private let gameLogoView = PlaceholderView()
    private let playtimeViewLine1 = PlaceholderView()
    private let playtimeViewLine2 = PlaceholderView()
    private let gameNameView = PlaceholderView()
    
    private let friendAvatarView = PlaceholderView()
    private let friendNameView = PlaceholderView()
    private let friendOnlineBadgeView = PlaceholderView()
    private let friendOnlineStatusView = PlaceholderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAvatarSection()
        setupGamesSection()
        setupFriendsSection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        startShimmering()
    }
    
    private func setupAvatarSection() {
        if #available(iOS 11.0, *) {
            backgroundColor = UIColor(named: "Background")
        } else {
            backgroundColor = .background
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.left.equalToSuperview().inset(20).priority(.required)
            make.height.width.equalTo(100).priority(.init(999))
        }
        
        addSubview(nameView)
        nameView.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(20)
            make.top.equalToSuperview().inset(70)
            make.height.equalTo(24)
        }
        
        addSubview(onlineBadgeView)
        onlineBadgeView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(77)
            make.right.equalToSuperview().inset(27)
            make.left.equalTo(nameView.snp.right).offset(20)
            make.height.width.equalTo(15)
        }
        
        addSubview(onlineStatusView)
        onlineStatusView.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(20)
            make.width.equalTo(45)
            make.height.equalTo(15)
            make.top.equalTo(nameView.snp.bottom).offset(20)
        }
    }
    
    private func setupGamesSection() {
        addSubview(gameLogoView)
        gameLogoView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(avatarView.snp.bottom).offset(95)
            make.width.equalTo(186)
            make.height.equalTo(64)
        }
        
        let stackView = UIStackView(arrangedSubviews: [playtimeViewLine1, playtimeViewLine2])
        stackView.spacing = 5
        stackView.axis = .vertical
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalTo(gameLogoView.snp.right).offset(20)
            make.centerY.equalTo(gameLogoView.snp.centerY)
        }
        
        playtimeViewLine1.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
        
        playtimeViewLine2.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        addSubview(gameNameView)
        gameNameView.snp.makeConstraints { make in
            make.top.equalTo(gameLogoView.snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.left.equalToSuperview().inset(20)
        }
        
    }
    
    private func setupFriendsSection() {
        addSubview(friendAvatarView)
        friendAvatarView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(gameNameView.snp.bottom).offset(95)
            make.width.height.equalTo(50)
        }
        
        let stackView = UIStackView(arrangedSubviews: [friendNameView, friendOnlineStatusView])
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(friendAvatarView.snp.top)
            make.left.equalTo(friendAvatarView.snp.right).offset(20)
        }
        
        friendNameView.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.width.equalTo(120)
        }
        
        addSubview(friendOnlineBadgeView)
        friendOnlineBadgeView.snp.makeConstraints { make in
            make.top.equalTo(gameNameView.snp.bottom).offset(100)
            make.right.equalToSuperview().inset(20)
            make.height.width.equalTo(10)
        }
    }
}

private extension UIView {
    func startShimmering() {
        let light = UIColor.white.cgColor
        let alpha = UIColor.gray.withAlphaComponent(0.7).cgColor
            
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, light, alpha]
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        gradient.locations = [0.4, 0.5, 0.6]
        self.layer.mask = gradient
            
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 0.7
        animation.repeatCount = Float.greatestFiniteMagnitude
        gradient.add(animation, forKey: "shimmer")
    }
}
