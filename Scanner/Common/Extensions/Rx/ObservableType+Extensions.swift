//
//  ObservableType+Extensions.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

extension ObservableType {
    
    func onNext(_ onNext: ((Self.E) -> Void)?) -> Disposable {
        return subscribe(onNext: onNext)
    }
    
}

extension ObservableType where E == Void {
    
    static func just() -> Observable<Self.E> {
        return .just(())
    }
    
}
