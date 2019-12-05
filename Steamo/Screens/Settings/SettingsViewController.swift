//
//  SettingsViewController.swift
//  Steamo
//
//  Created by Max Kraev on 27.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    fileprivate let viewModel: SettingsViewModel
    
    private lazy var logoutButton: SteamoButton = {
        let button = SteamoButton()
        button.setTitle("Log out", for: .normal)
        button.backgroundColor = .accent
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return button
    }()

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor(named: "Background")
        } else {
            view.backgroundColor = .background
        }

        title = "Settings"
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    //MARK: Actions
    
    @objc private func logout() {
        NotificationCenter.default.post(name: .WillLogout, object: nil)
        SteamUser.remove()
        NotificationCenter.default.post(name: .DidLogout, object: nil)
    }
}
