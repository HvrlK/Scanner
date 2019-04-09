//
//  UIViewController+Extension.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import UIKit

extension UIViewController {
    fileprivate static let viewControllerWordCount = "ViewController".count
}

protocol Navigatable where Self: UIViewController {}

extension UIViewController: Navigatable {}

extension Navigatable {
    static var storyboardName: String {
        let name = nameOfClass
        let index = name.index(name.startIndex, offsetBy: name.count - viewControllerWordCount)
        let prefix = name.prefix(upTo: index)
        return String(prefix)
    }
    
    static func controllerInStoryboard(_ storyboard: UIStoryboard, identifier: String) -> Self {
        return instantiateControllerInStoryboard(storyboard, identifier: identifier)
    }
    
    static func controllerInStoryboard(_ storyboard: UIStoryboard) -> Self {
        return controllerInStoryboard(storyboard, identifier: nameOfClass)
    }
    
    static func instantiate<T: UIViewController>(_ storyboard: UIStoryboard) -> T {
        return storyboard.instantiateViewController(withIdentifier: "\(storyboard.name)ViewController") as! T
    }
    
    static func instantiate(initializer: (Self) -> Void = { _ in }) -> Self {
        let name = nameOfClass
        let index = name.index(name.startIndex, offsetBy: name.count - viewControllerWordCount)
        let prefix = name.prefix(upTo: index)
        let vc = controllerInStoryboard(UIStoryboard(name: String(prefix), bundle: nil))
        initializer(vc)
        return vc
    }
    
    private static func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    static func instantiateNavigation(initializer: (Self) -> Void = { _ in }) -> UINavigationController {
        let storyboardName = self.storyboardName
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "\(storyboardName)NavigationController") as! UINavigationController
        if let vc = navigationController.viewControllers.first as? Self {
            initializer(vc)
        }
        return navigationController
    }
}
