//
//  AppearanceConfigurator.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 5/12/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import UIKit

struct AppearanceConfiguretor {
    func configure() {
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}
