//
//  UIControl+Rx.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIControl {
    func taps(_ throttle: RxTimeInterval = 0.2) -> Observable<Void> {
        return controlEvent(.touchUpInside)
            .throttle(0.2, latest: false, scheduler: MainScheduler.instance)
    }
}

extension Reactive where Base: UIBarButtonItem {
    func taps(_ throttle: RxTimeInterval = 0.2) -> Observable<Void> {
        return tap.throttle(0.2, latest: false, scheduler: MainScheduler.instance)
    }
}
