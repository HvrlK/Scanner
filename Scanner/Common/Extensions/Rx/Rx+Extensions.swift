//
//  Rx+Extensions.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct AssociatedKeys {
    static var disposeBag: UInt8 = 0
    static var action: UInt8 = 0
}

extension Reactive where Base: AnyObject {
    var bag: DisposeBag {
        get {
            if let disposeObject = objc_getAssociatedObject(base, &AssociatedKeys.disposeBag) as? DisposeBag {
                return disposeObject
            }
            let disposeObject = DisposeBag()
            objc_setAssociatedObject(base, &AssociatedKeys.disposeBag, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return disposeObject
        }
        
        set {
            objc_setAssociatedObject(base, &AssociatedKeys.disposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
