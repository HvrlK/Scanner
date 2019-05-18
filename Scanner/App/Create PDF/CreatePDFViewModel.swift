//
//  CreatePDFViewModel.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import Action
import PDFKit

class CreatePDFViewModel: ViewModel {
    
    private(set) lazy var actionCreate = Action<Void, String> { [weak self] _ in
        guard let self = self else { return .empty() }
        let pdfDocument = PDFDocument()
        let images = self.images
        for index in images.indices {
            if let page = PDFPage(image: images[index]) {
                pdfDocument.insert(page, at: index)
            }
        }
        let name: String
        if self.nameOfDocument.value.isEmpty {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            name = dateFormatter.string(from: date)
        } else {
            name = self.nameOfDocument.value
        }
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = (documentsDirectory as NSString).appendingPathComponent("Scanner/\(name).pdf") as String

        pdfDocument.write(toFile: filePath)
        return .just(filePath)
    }
    
    let nameOfDocument = BehaviorRelay<String>(value: "")
    var images: [UIImage]
    
    init(model: ImageScannerResults) {
        let image = model.doesUserPreferEnhancedImage ? (model.enhancedImage ?? model.scannedImage) : model.scannedImage
        self.images = [image]
        super.init()
    }
    
}

extension UIImage: IdentifiableType {
    
    public var identity: Data? {
        return self.pngData()
    }
    
    public typealias Identity = Data?
    
}
