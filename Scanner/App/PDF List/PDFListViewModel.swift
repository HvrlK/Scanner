//
//  PDFListViewModel.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Action

class PDFListViewModel: ViewModel {
        
    let items: BehaviorRelay<[URL]>
    
    private(set) lazy var actionDelete = Action<Int, Void> { [weak self] index in
        guard let self = self else { return .empty() }
        var urls = self.items.value
        let url = urls.remove(at: index)
        do {
            try FileManager.default.removeItem(at: url)
            self.items.accept(urls)
        } catch {
            return .error(error)
        }
        return .just()
    }
    
    override init() {
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = (documentsDirectory as NSString).appendingPathComponent("Scanner/") as String

        let url = URL(fileURLWithPath: filePath)
        let fileManager = FileManager.default
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            self.items = BehaviorRelay(value: fileURLs)
        } catch {
            self.items = BehaviorRelay(value: [])
            print("Error while enumerating files \(url.path): \(error.localizedDescription)")
        }
        
        super.init()
    }
    
}

extension URL: IdentifiableType {
    
    public typealias Identity = String
    
    public var identity: String {
        return self.path
    }
    
}
