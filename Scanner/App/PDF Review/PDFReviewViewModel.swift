//
//  PDFReviewViewModel.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import Foundation

class PDFReviewViewModel: ViewModel {
    
    enum Kind {
        case create
        case open
    }
    
    let kind: Kind
    
    let filePath: String
    
    init(_ model: String, kind: Kind) {
        self.filePath = model
        self.kind = kind
    }
    
}
