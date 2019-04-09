//
//  UIStoryboard+Extensions.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    var name: String {
        guard let name = self.value(forKey: "name") as? String else { fatalError("\(#file).\(#function) UIStoryboard name key not found") }
        return name
    }
    
}
