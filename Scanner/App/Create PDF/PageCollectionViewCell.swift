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

protocol PageCollectionViewCellDelegate: class {
    func didRemove(_ model: UIImage)
}

class PageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: PageCollectionViewCellDelegate?
    
    var bag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func configureView(_ model: UIImage, editing: BehaviorRelay<Bool>) {
        self.layer.cornerRadius = 15
        imageView.image = model
        deleteButton.alpha = 0
        bindEditing(editing)
        bindDeleteButton(model)
    }
    
    private func bindEditing(_ editing: BehaviorRelay<Bool>) {
        editing
            .onNext { [weak self] editing in
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.deleteButton.alpha = editing ? 1 : 0
                })
            }.disposed(by: bag)
    }
    
    private func bindDeleteButton(_ model: UIImage) {
        deleteButton.rx.taps()
            .onNext { [weak self] in
                self?.delegate?.didRemove(model)
            }.disposed(by: bag)
    }
}
