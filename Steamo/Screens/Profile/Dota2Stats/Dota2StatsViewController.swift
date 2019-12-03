//
//  Dota2StatsViewControllert.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class Dota2StatsViewController: UIViewController {
    
    //MARK:- Properties
    
    private let viewModel: Dota2StatsViewModel
    
    //MARK:- Lifecycle
    
    init(viewModel: Dota2StatsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK:- Methods
    
    private func setup() {
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor(named: "Background")
        } else {
            view.backgroundColor = .background
        }
        
        title = "Dota2 Stats"
    }
}
