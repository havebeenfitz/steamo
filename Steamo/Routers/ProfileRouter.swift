//
//  ProfileRouter.swift
//  Steamo
//
//  Created by Max Kraev on 27.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class ProfileRouter {
    
    func routeToFriendProfile(from vc: UIViewController, steamId: String) {
        let profileViewModel = ProfileViewModel(networkAdapter: NetworkAdapter(),
                                                state: .friend(steamId: steamId))
        let friendProfileVC = ProfileViewController(viewModel: profileViewModel,
                                                    router: self)
        vc.navigationController?.pushViewController(friendProfileVC, animated: true)
    }
}

