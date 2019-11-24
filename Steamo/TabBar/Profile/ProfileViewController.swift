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
    
    /// Стим айди игрока
    var steamId: String? {
        get {
            UserDefaults.standard.string(forKey: SteamoUserDefaultsKeys.steamId)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: SteamoUserDefaultsKeys.steamId)
        }
    }
    
    /// Кнопка авторизации
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("Log in", for: .normal)
        button.addTarget(nil, action: #selector(loginButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc private func loginButtonDidTap() {
        let loginVC = LoginViewController(nibName: nil, bundle: nil)
        loginVC.completion = { steamId in
            print(steamId)
        }
        present(loginVC, animated: true)
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
}
