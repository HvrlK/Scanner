//
//  RxSection.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import Foundation
import RxDataSources

typealias SimpleSection<T> = RxSection<T, Void>
typealias SimpleAnimatableSection<T: IdentifiableType & Equatable> = RxAnimatableSection<T, String, String>

extension RxSection where V == Void {
    init(items: [T] = [T]()) {
        self.init(header: (), items: items)
    }
}

struct RxSection<T,V> {
    var header: V
    var items: [T]
    
    init(header: V, items: [T] = [T]()) {
        self.header = header
        self.items = items
    }
}

struct RxAnimatableSection<T: IdentifiableType & Equatable, I : Hashable, H> : AnimatableSectionModelType {
    
    typealias Identity = I
    
    var identity: I
    var header: H
    var items: [T]
    
    init(original: RxAnimatableSection<T, I, H>, items: [T]) {
        self = original
        self.items = items
    }
    
    init(identity: I, header: H, items: [T] = [T]()) {
        self.identity = identity
        self.header = header
        self.items = items
    }
}

extension RxAnimatableSection where I == H {
    init(header: H, items: [T] = [T]()) {
        self.init(identity: header, header: header, items: items)
    }
}

extension RxAnimatableSection where I == H, I == String {
    init(header: String = "", items: [T] = [T]()) {
        self.init(identity: header, header: header, items: items)
    }
}

extension RxAnimatableSection where I == H, I == Int {
    init(header: Int = 0, items: [T] = [T]()) {
        self.init(identity: header, header: header, items: items)
    }
}

extension RxSection : SectionModelType {
    public typealias Item = T
    
    init(original: RxSection<T, V>, items: [T]) {
        self = original
        self.items = items
    }
}

extension Array : SectionModelType {
    public typealias Item = Element
    
    public var items: [Element] {
        return self
    }
    
    public init(original: Array<Element>, items: [Element]) {
        self = original
    }
}

