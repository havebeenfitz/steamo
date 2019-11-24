//
//  ProfileViewController.swift
//  Steamo
//
//  Created by Max Kraev on 24.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    /// Вьюмодель экрана
    private let viewModel: ProfileViewModel
    
    private lazy var loginStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logoImageView, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    /// Логотип стима
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "steamlogo")
        if #available(iOS 11.0, *) {
            imageView.tintColor = UIColor(named: "Text")
        } else {
            imageView.tintColor = .text
        }
        return imageView
    }()
    
    /// Кнопка авторизации
    private lazy var loginButton: SteamoButton = {
        let button = SteamoButton()
        if #available(iOS 11.0, *) {
            button.backgroundColor = UIColor(named: "Accent")
            button.titleLabel?.textColor = UIColor(named: "Background")
        } else {
            button.backgroundColor = .accent
            button.titleLabel?.textColor = .background
        }
        button.setTitle("Sing in", for: .normal)
        button.addTarget(nil, action: #selector(loginButtonDidTap), for: .touchUpInside)
        button.isHidden = viewModel.steamId != nil
        return button
    }()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        toggleLogoutButton()
    }
    
    @objc private func loginButtonDidTap() {
        let loginVC = LoginViewController(nibName: nil, bundle: nil)
        let loginNavigationVC = loginVC.wrapInNavigation()
        loginVC.completion = { [weak self] steamId in
            self?.viewModel.steamId = steamId
            self?.loginStackView.isHidden = true
            self?.toggleLogoutButton()
        }
        present(loginNavigationVC, animated: true)
    }
    
    private func setup() {
        title = "Profile"
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor(named: "Background")
        } else {
            view.backgroundColor = .background
        }

        view.addSubview(loginStackView)
        loginStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(200)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
    
    private func toggleLogoutButton() {
        if viewModel.steamId != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"),
                                                                       style: .plain,
                                                                       target: self,
                                                                       action: #selector(logout))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
       
    }
    
    @objc private func logout() {
        viewModel.logout()
        loginStackView.isHidden = false
        toggleLogoutButton()
    }
    
}
