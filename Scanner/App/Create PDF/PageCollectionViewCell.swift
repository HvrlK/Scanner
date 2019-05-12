//
//  PageCollectionViewCell.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configureView(_ model: UIImage) {
        imageView.image = model
    }
}
