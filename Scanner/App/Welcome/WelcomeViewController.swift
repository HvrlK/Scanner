//
//  WelcomeViewController.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WelcomeViewController: BaseViewController {
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var openButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindCreateButton()
        bindOpenButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func bindCreateButton() {
        createButton.rx.taps()
            .onNext { [weak self] in
                let scannerViewController = ImageScannerController()
                scannerViewController.imageScannerDelegate = self
                self?.present(scannerViewController, animated: true)
            }.disposed(by: rx.bag)
    }
    
    private func bindOpenButton() {
        openButton.rx.taps()
            .onNext { [weak self] in
                let vc = PDFListViewController.instantiate()
                self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: rx.bag)
    }
    
    private func openCreatePDFViewController(with results: ImageScannerResults) {
        let vc = CreatePDFViewController.instantiate()
        vc.setup(results)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension WelcomeViewController: ImageScannerControllerDelegate {
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
        presentErrorAlert()
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true) { [weak self] in
            self?.openCreatePDFViewController(with: results)
        }
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true)
    }
    
}
