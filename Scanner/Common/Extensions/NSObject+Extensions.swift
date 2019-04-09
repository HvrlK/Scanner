//
//  NSObject+Extensions.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import Foundation

extension NSObject {
    class var nameOfClass: String {
        let className = NSStringFromClass(self)
        let index = className.index(after: className.lastIndex(of: ".")!)
        return String(className.suffix(from: index))
    }
}
