//
//  BaseViewController.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    deinit {
        print("Deinit \(#file)")
    }
    
}

extension BaseViewController {
    
    func presentErrorAlert() {
        AlertBuilder(self)
            .title("Помилка")
            .message("Спробуйте ще раз")
            .actionOk()
            .present()
    }
    
}
